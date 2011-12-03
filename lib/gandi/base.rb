require 'xmlrpc/client'
require 'openssl'

#Common session, account and call methods
module Gandi
  class Base
    TIMEOUT_EXCEPTIONS = [EOFError, Errno::EPIPE, OpenSSL::SSL::SSLError]

    URL = "https://api.gandi.net/xmlrpc/"
    TEST_URL = "https://api.ote.gandi.net/xmlrpc/"

    attr_reader :session_id, :handler

    public

    def initialize(login, password, uri = nil)
      @login = login
      @password = password
      @uri = uri
      raise ArgumentError.new("You must provide an URL when using Gandi::Base directly") unless @uri
    end

    #Calls a RPC method, transparently providing the session id
    def call(method, *arguments)
      raise "You have to log in before using methods requiring a session id" unless logged_in?
      raw_call(method.to_s, @session_id, *arguments)
    end

    #Instanciates a rpc handler and log in to the interface to retrieve a session id
    def login
      @handler = XMLRPC::Client.new_from_uri(@uri)
      #Get rid of SSL warnings "peer certificate won't be verified in this SSL session"
      #See http://developer.amazonwebservices.com/connect/thread.jspa?threadID=37139
      #and http://blog.chmouel.com/2008/03/21/ruby-xmlrpc-over-a-self-certified-ssl-with-a-warning/
      if @handler.instance_variable_get('@http').use_ssl?
        @handler.instance_variable_get('@http').instance_variable_get("@ssl_context").verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      @session_id = raw_call("login", @login, @password, false)
    end

    #Gets a new session id by switching to another handle
    def su(handle)
      @session_id = call("su", handle)
    end

    #Changes password
    def password(password)
      @password = password
      call("password", password)
    end

    #Current prepaid account balance
    def account_balance
      call('account_balance')
    end

    #Currency name used with the prepaid account
    def account_currency
      call('account_currency')
    end

    def self.login(login, password, uri = nil)
      client = self.new(login, password, uri)
      client.login
      return client
    end

    private

    #Handle RPC calls and exceptions
    #A reconnection system is used to work around what seems to be a ruby bug :
    #When waiting during 15 seconds between calls, a timeout is reached and the RPC handler starts throwing various exceptions
    #EOFError, Errno::EPIPE, then OpenSSL::SSL::SSLError.
    #When this happens, another handler and another session are created
    #Exceptions are not handled if happening two times consecutively, or during a login call
    #TODO: This method may be optimized by only creating another handler and keeping the session id.
    #In this case a server timeout of 12 hours (see the Gandi documentation) may be reached more easily and should be handled.
    def raw_call(*args)
      begin
        raise "no connexion handler is set" unless @handler
        result = @handler.call(*args)
        @reconnected = false unless (args.first == 'login')
        return result
      rescue StandardError => e
        case e
        when XMLRPC::FaultException
          raise (e.faultCode.to_s.chars.first == '5' ? Gandi::DataError : Gandi::ServerError), e.faultString
        when *TIMEOUT_EXCEPTIONS
          if @reconnected || (args.first == 'login')
            raise e #only one retry, and no retries if logging in
          else
            @reconnected = true
            args[1] = login #use the new session string
            raw_call(*args)
          end
        else
          @reconnected = false
          raise e
        end
      end
    end

    def logged_in?
      @session_id.is_a? String
    end

    #Raises a NoMethodError exception.
    #Used for methods that are presents in the API but not yet available
    def not_supported
      raise NoMethodError.new("This method is not supported and will be available in v1.10 of the API")
    end

  end
end
