require 'test_helper'

class BaseTest < ActiveSupport::TestCase
  
  def setup
    @login = 'XX000-Gandi'
    @password = 'dummy'
    @uri = Gandi::Domain::TEST_URL
    
    @session_id = "session id"
  end
  
  context "an instance of Gandi::Base without an URL provided" do
    should "raise an error when trying to initialize" do
      assert_raise ArgumentError do
        Gandi::Base.new @login, @password
      end
    end
    
    should "raise an error when trying to login directly" do
      assert_raise ArgumentError do
        Gandi::Base.login @login, @password
      end
    end
  end
  
  context "an instance of Gandi::Base with an URL provided" do
    setup do
      @gandi_base = Gandi::Base.new @login, @password, @uri
    end
    
    context "without logging in" do
      should "raise a runtime error error when trying to call an arbitrary method" do
        assert_raise RuntimeError do
          @gandi_base.call "mymethod"
        end
      end
      
      should "raise a runtime error error when trying to call an account method" do
        %w(account_balance account_currency).each do |method|
          assert_raise RuntimeError do
            @gandi_base.send(method)
          end
        end
      end
      
      should "raise a runtime error error when trying to su or change password" do
        assert_raise RuntimeError do
          @gandi_base.su 'anotherhandle-Gandi'
        end
        
        assert_raise RuntimeError do
          @gandi_base.password 'mypassword'
        end
      end
      
      should "raise a runtime error error when trying to use raw_call" do
        assert_raise RuntimeError do
          @gandi_base.send :raw_call, "mymethod"
        end
      end
      
      should "have a handler set to nil" do
        assert @gandi_base.handler.nil?
      end
      
      should "have a session id set to nil" do
        assert @gandi_base.session_id.nil?
      end
    end
    
    context "logging in" do
      should "raise an error if the account does not exist" do
        XMLRPC::Client.any_instance.expects(:call).raises(Gandi::DataError.new("DataError: account does not exist [login: #{@login}]"))
        assert_raise Gandi::DataError do
          @gandi_base.login
        end
      end
      
      should "raise an error if the password is wrong" do
        XMLRPC::Client.any_instance.expects(:call).raises(Gandi::DataError.new("DataError: invalid value for password [incorrect password]"))
        assert_raise Gandi::DataError do
          @gandi_base.login
        end
      end
      
      context "with correct credentials" do
        setup do
          XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).returns(@session_id)
        end
        
        should "return a session string when using correct credentials and store it"  do
          session_id = @gandi_base.login
          assert session_id.is_a? String
          assert_equal session_id, @gandi_base.session_id
        end
      end
    end
  end
  
  context "An instance of Gandi::Base using login directly" do
    setup do
      XMLRPC::Client.any_instance.expects(:call).at_least_once.with("login", @login, @password, false).returns(@session_id)
      @gandi_base = Gandi::Base.login @login, @password, @uri
    end
    
    should "have a session id" do
      assert_equal @session_id, @gandi_base.session_id
    end
    
    should "have a handler" do
      assert @gandi_base.handler
    end
    
    should "get the account balance" do
      @gandi_base.handler.expects(:call).with("account_balance", @session_id).returns(1000)
      assert @gandi_base.account_balance.is_a? Numeric
    end
    
    should "get the currency name" do
      @gandi_base.handler.expects(:call).with("account_currency", @session_id).returns("EUR")
      assert_match /\w{3}/, @gandi_base.account_currency
    end
    
    should "change the session id when suing to another handle" do
      @gandi_base.handler.expects(:call).with("su", @session_id, "NEWHANDLE-Gandi").returns("new session id")
      
      @gandi_base.su "NEWHANDLE-Gandi"
      assert_equal "new session id", @gandi_base.session_id
    end
    
    should "change the password" do
      @gandi_base.handler.expects(:call).with("password", @session_id, "newpassword").returns(true)
      
      assert @gandi_base.password "newpassword"
    end
  end
  
  context "An instance of Gandi::Base expecting failures" do
    setup do
    end
    
    should "retry once when failing after a timeout" do
      tries = states('tries').starts_as('none')
      XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).returns('sid1').when(tries.is('none')).then(tries.is('first'))
      XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).returns('sid2').when(tries.is('first')).then(tries.is('second'))
      XMLRPC::Client.any_instance.expects(:call).with("account_balance", 'sid1').raises(EOFError).when(tries.is('first'))
      XMLRPC::Client.any_instance.expects(:call).with("account_balance", 'sid2').returns(1000).when(tries.is('second'))
      
      @gandi_base = Gandi::Base.login @login, @password, @uri
      assert_equal 1000, @gandi_base.account_balance
    end
    
    should "fail after trying unsuccesfully two times" do
      tries = states('tries').starts_as('none')
      XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).returns('sid1').when(tries.is('none')).then(tries.is('first'))
      XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).returns('sid2').when(tries.is('first')).then(tries.is('second'))
      XMLRPC::Client.any_instance.expects(:call).with("account_balance", 'sid1').raises(EOFError).when(tries.is('first'))
      XMLRPC::Client.any_instance.expects(:call).with("account_balance", 'sid2').raises(Errno::EPIPE).when(tries.is('second'))
      
      @gandi_base = Gandi::Base.login @login, @password, @uri
      
      assert_raise *Gandi::Base::TIMEOUT_EXCEPTIONS do
        @gandi_base.account_balance
      end
    end
    
    should "fail when directly failing on login" do
      XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).raises(EOFError)
      
      assert_raise *Gandi::Base::TIMEOUT_EXCEPTIONS do
        @gandi_base = Gandi::Base.login @login, @password, @uri
      end
    end
    
    should "fail after trying to login when retrying" do
      tries = states('tries').starts_as('none')
      XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).returns('sid1').when(tries.is('none')).then(tries.is('first'))
      XMLRPC::Client.any_instance.expects(:call).with("login", @login, @password, false).raises(EOFError).when(tries.is('first')).then(tries.is('second'))
      XMLRPC::Client.any_instance.expects(:call).with("account_balance", 'sid1').raises(EOFError).when(tries.is('first'))
      
      @gandi_base = Gandi::Base.login @login, @password, @uri
      
      assert_raise *Gandi::Base::TIMEOUT_EXCEPTIONS do
        @gandi_base.account_balance
      end
    end
  end
  
end
