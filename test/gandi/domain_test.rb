require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  def setup
    @login = 'XX000-Gandi'
    @password = 'dummy'
    @uri = Gandi::Domain::TEST_URL
    
    @session_id = "session id"
  end
  
  context "a new logged in Gandi::Domain instance" do
    setup do
      XMLRPC::Client.any_instance.expects(:call).at_least_once.with("login", @login, @password, false).returns(@session_id)
      @gandi_domain = Gandi::Domain.login @login, @password, @uri
    end
    
    should "get domain list" do
      @gandi_domain.handler.expects(:call).with("domain_list", @session_id).returns(["mydomain.com"])
      
      assert @gandi_domain.domain_list.is_a? Array
    end
    
    context "mocking domain_available calls" do
      setup do
        @gandi_domain.handler.expects(:call).with("domain_available", @session_id, ['testdomain.com']).returns({"testdomain.com" => false})
      end
      
      should "return a hash when providing an array" do
        assert_equal false, @gandi_domain.domain_available('testdomain.com')
      end
      
      should "return a boolean when providing a single domain" do
        assert_equal({"testdomain.com" => false}, @gandi_domain.domain_available(['testdomain.com']))
      end
    end
    
    context "with an existing domain" do
      setup do
        @domain_name = "mydomain.com"
      end
      
      should "lock a domain" do
        @gandi_domain.handler.expects(:call).with("domain_lock", @session_id, @domain_name).returns(rand(9000))
        
        assert @gandi_domain.domain_lock(@domain_name).is_a? Integer
      end
      
      should "unlock a domain" do
        @gandi_domain.handler.expects(:call).with("domain_unlock", @session_id, @domain_name).returns(rand(9000))
        
        assert @gandi_domain.domain_unlock(@domain_name).is_a? Integer
      end
      
      #TODO: better test (use a hash similar to a real api call result)
      should "get infos on a domain" do
        @gandi_domain.handler.expects(:call).with("domain_info", @session_id, @domain_name).returns({})
        
        assert @gandi_domain.domain_info(@domain_name).is_a? Hash
      end
      
      should "renew a domain for 8 years" do
        @gandi_domain.handler.expects(:call).with("domain_renew", @session_id, @domain_name, 8).returns(rand(9000))
        
        assert @gandi_domain.domain_renew(@domain_name, 8).is_a? Integer
      end
      
      should "not renew a domain for 11 years" do
        assert_raise ArgumentError do
          @gandi_domain.domain_renew(@domain_name, 11)
        end
      end
      
      should "restore a domain" do
        @gandi_domain.handler.expects(:call).with("domain_restore", @session_id, @domain_name).returns(rand(9000))
        
        assert @gandi_domain.domain_restore(@domain_name).is_a? Integer
      end
      
      should "not delete a domain" do
        assert_raise NoMethodError do
          @gandi_domain.domain_del(@domain_name)
        end
      end
      
      should "check if domain can be transferred" do
        @gandi_domain.handler.expects(:call).with("domain_transfer_in_available", @session_id, @domain_name).twice.returns(true)
        
        available = @gandi_domain.domain_transfer_in_available(@domain_name)
        assert_equal true, available
        
        assert_equal available, @gandi_domain.domain_transfer_in_available?(@domain_name)
      end
      
      should "transfer a domain in" do
        owner_handle, admin_handle, tech_handle, billing_handle = 'owner_handle', "admin_handle", 'tech_handle', 'billing_handle'
        nameservers = ['127.0.0.1']
        @gandi_domain.handler.expects(:call).with("domain_transfer_in", @session_id, @domain_name, owner_handle, admin_handle, tech_handle, billing_handle, nameservers).returns(rand(9000))
        
        assert @gandi_domain.domain_transfer_in(@domain_name, owner_handle, admin_handle, tech_handle, billing_handle, nameservers).is_a? Integer
      end
      
      should "not transfer a domain out" do
        assert_raise NoMethodError do
          @gandi_domain.domain_transfer_out(@domain_name, true)
        end
      end
      
      should "not trade a domain" do
        assert_raise NoMethodError do
          @gandi_domain.domain_trade(@domain_name, 'owner_handle', 'admin_handle', 'tech_handle', 'billing_handle')
        end
      end
      
      should "not change owner of a domain" do
        assert_raise NoMethodError do
          @gandi_domain.domain_change_owner(@domain_name, 'new_owner')
        end
      end
      
      should "change contact for a domain" do
        @gandi_domain.handler.expects(:call).with("domain_change_contact", @session_id, @domain_name, 'admin', 'new-handle').returns(rand(9000))
        
        assert @gandi_domain.domain_change_contact(@domain_name, 'admin', 'new-handle').is_a? Integer
      end
    end
    
    should "create a domain" do
      domain, period, owner_handle, admin_handle, tech_handle, billing_handle = 'mynewdomain.com', 7, 'owner_handle', "admin_handle", 'tech_handle', 'billing_handle'
      nameservers = ['127.0.0.1']
      @gandi_domain.handler.expects(:call).with("domain_create", @session_id, domain, period, owner_handle, admin_handle, tech_handle, billing_handle, nameservers).returns(rand(9000))
      
      assert @gandi_domain.domain_create(domain, period, owner_handle, admin_handle, tech_handle, billing_handle, nameservers).is_a? Integer
    end
    
    should "get domains list" do
      tlds = ["info", "be", "eu", "name", "biz", "us", "org", "com", "net", "mobi", "ch", "li", "at", "asia", "de", "nu", "cz", "tw", "es", "lu", "pl", "pro", "me", "in"]
      
      @gandi_domain.handler.expects(:call).with("tld_list", @session_id).returns(tlds)
      
      assert_equal tlds, @gandi_domain.tld_list
    end
    
  end
end
