require 'xmlrpc/client'
require 'openssl'

#Common session, account and call methods
module Gandi
  class Base
    
    TIMEOUT_EXCEPTIONS = [EOFError, Errno::EPIPE, OpenSSL::SSL::SSLError]
    
    attr_reader :login, :handler, :session_id
    
    private
    
    def self.define_getter(method_name)
      define_method(method_name) {
        call(method_name) 
      }
    end
    
    public
    
    def initialize(login, password, uri = nil)
      @login = login
      @password = password
      @uri = uri || self.class.const_get(:URL)
    end
    
    def call(method, *arguments)
      raw_call(method.to_s, @session_id, *arguments)
    end
    
    def login
      @handler = XMLRPC::Client.new_from_uri(@uri)
      #Get rid of SSL warnings "peer certificate won't be verified in this SSL session"
      #See http://developer.amazonwebservices.com/connect/thread.jspa?threadID=37139
      #and http://blog.chmouel.com/2008/03/21/ruby-xmlrpc-over-a-self-certified-ssl-with-a-warning/
      @handler.instance_variable_get('@http').instance_variable_get("@ssl_context").verify_mode = OpenSSL::SSL::VERIFY_NONE
      @session_id = raw_call("login", @login, @password, false)
    end
    
    def su(handle)
      @session_id = call("su", handle)
    end
    
    def password(password)
      @password = password
      call("password", password)
    end
    
    def self.login(login, password, host = nil)
      client = self.new(login, password, host)
      client.login
      return client
    end
    
    #Account methods
    %w(account_balance account_currency).each do |method|
      define_getter(method)
    end
    
    private
    
    def raw_call(*args)
      begin
        raise LoadError, "no connexion handler is set." unless @handler.is_a?(XMLRPC::Client)
        result = @handler.call(*args)
        @reconnected = false
        return result
      rescue StandardError => e
        case e
        when XMLRPC::FaultException
          raise (e.faultCode.to_s.chars.first == '5' ? Gandi::DataError : Gandi::ServerError), e.faultString
        when *TIMEOUT_EXCEPTIONS
          if @reconnected || (args.first == 'login')
            raise e #only one retry
          else
            @reconnected = true
            login
            raw_call(*args)
          end
        else
          @reconnected = false
          raise e
        end
      end
    end
    
  end
end
