require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  def setup
    @login = 'XX000-Gandi'
    @password = 'dummy'
    @uri = Gandi::Domain::TEST_URL
    
    @session_id = "session id"
    @sample_domain_name = "mydomain.com"
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
        assert_equal({"testdomain.com" => false}, @gandi_domain.domain_available(['testdomain.com']))
      end
      
      should "return a boolean when providing a single domain" do
        assert_equal false, @gandi_domain.domain_available('testdomain.com')
      end
    end
    
    context "with an existing domain" do
      should "lock a domain" do
        @gandi_domain.handler.expects(:call).with("domain_lock", @session_id, @sample_domain_name).returns(rand(9000))
        
        assert @gandi_domain.domain_lock(@sample_domain_name).is_a? Integer
      end
      
      should "unlock a domain" do
        @gandi_domain.handler.expects(:call).with("domain_unlock", @session_id, @sample_domain_name).returns(rand(9000))
        
        assert @gandi_domain.domain_unlock(@sample_domain_name).is_a? Integer
      end
      
      #TODO: better test (use a hash similar to a real api call result)
      should "get infos on a domain" do
        @gandi_domain.handler.expects(:call).with("domain_info", @session_id, @sample_domain_name).returns({})
        
        assert @gandi_domain.domain_info(@sample_domain_name).is_a? Hash
      end
      
      should "renew a domain for 8 years" do
        @gandi_domain.handler.expects(:call).with("domain_renew", @session_id, @sample_domain_name, 8).returns(rand(9000))
        
        assert @gandi_domain.domain_renew(@sample_domain_name, 8).is_a? Integer
      end
      
      should "not renew a domain for 11 years" do
        assert_raise ArgumentError do
          @gandi_domain.domain_renew(@sample_domain_name, 11)
        end
      end
      
      should "restore a domain" do
        @gandi_domain.handler.expects(:call).with("domain_restore", @session_id, @sample_domain_name).returns(rand(9000))
        
        assert @gandi_domain.domain_restore(@sample_domain_name).is_a? Integer
      end
      
      should "not delete a domain" do
        assert_raise NoMethodError do
          @gandi_domain.domain_del(@sample_domain_name)
        end
      end
      
      should "check if domain can be transferred" do
        @gandi_domain.handler.expects(:call).with("domain_transfer_in_available", @session_id, @sample_domain_name).twice.returns(true)
        
        available = @gandi_domain.domain_transfer_in_available(@sample_domain_name)
        assert_equal true, available
        
        assert_equal available, @gandi_domain.domain_transfer_in_available?(@sample_domain_name)
      end
      
      should "transfer a domain in" do
        owner_handle, admin_handle, tech_handle, billing_handle = 'owner_handle', "admin_handle", 'tech_handle', 'billing_handle'
        nameservers = ['127.0.0.1']
        @gandi_domain.handler.expects(:call).with("domain_transfer_in", @session_id, @sample_domain_name, owner_handle, admin_handle, tech_handle, billing_handle, nameservers).returns(rand(9000))
        
        assert @gandi_domain.domain_transfer_in(@sample_domain_name, owner_handle, admin_handle, tech_handle, billing_handle, nameservers).is_a? Integer
      end
      
      should "not transfer a domain out" do
        assert_raise NoMethodError do
          @gandi_domain.domain_transfer_out(@sample_domain_name, true)
        end
      end
      
      should "not trade a domain" do
        assert_raise NoMethodError do
          @gandi_domain.domain_trade(@sample_domain_name, 'owner_handle', 'admin_handle', 'tech_handle', 'billing_handle')
        end
      end
      
      should "not change owner of a domain" do
        assert_raise NoMethodError do
          @gandi_domain.domain_change_owner(@sample_domain_name, 'new_owner')
        end
      end
      
      should "change contact for a domain" do
        @gandi_domain.handler.expects(:call).with("domain_change_contact", @session_id, @sample_domain_name, 'admin', 'new-handle').returns(rand(9000))
        
        assert @gandi_domain.domain_change_contact(@sample_domain_name, 'admin', 'new-handle').is_a? Integer
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
    
    
    should "list name servers for a domain" do
      @gandi_domain.handler.expects(:call).with("domain_ns_list", @session_id, @sample_domain_name).returns([])
      
      assert @gandi_domain.domain_ns_list(@sample_domain_name).is_a? Array
    end
    
    should "add name servers for a domain" do
      @gandi_domain.handler.expects(:call).with("domain_ns_add", @session_id, @sample_domain_name, ['127.0.0.1']).returns(rand(9000))
      
      assert @gandi_domain.domain_ns_add(@sample_domain_name, ['127.0.0.1']).is_a? Integer
    end
    
    should "remove name servers for a domain" do
      @gandi_domain.handler.expects(:call).with("domain_ns_del", @session_id, @sample_domain_name, ['127.0.0.1']).returns(rand(9000))
      
      assert @gandi_domain.domain_ns_del(@sample_domain_name, ['127.0.0.1']).is_a? Integer
    end
    
    should "set name servers for a domain" do
      @gandi_domain.handler.expects(:call).with("domain_ns_set", @session_id, @sample_domain_name, ['127.0.0.1']).returns(rand(9000))
      
      assert @gandi_domain.domain_ns_set(@sample_domain_name, ['127.0.0.1']).is_a? Integer
    end
    
    
    should "list hosts for a domain" do
      @gandi_domain.handler.expects(:call).with("host_list", @session_id, @sample_domain_name).returns([])
      
      assert @gandi_domain.host_list(@sample_domain_name).is_a? Array
    end
    
    should "get IPs for a domain" do
      ips = ['127.0.0.1']
      @gandi_domain.handler.expects(:call).with("host_info", @session_id, @sample_domain_name).returns(ips)
      
      assert @gandi_domain.host_info(@sample_domain_name).is_a? Array
    end
    
    should "create a glue record for a host when providing multiple IPs" do
      ip_list  = ["1.2.3.4", "1.2.3.5"]
      @gandi_domain.handler.expects(:call).with("host_create", @session_id, @sample_domain_name, ip_list).returns(rand(9000))
      
      assert @gandi_domain.host_create(@sample_domain_name, ip_list).is_a? Integer
    end
    
    should "create a glue record for a host when providing an unique IP" do
      ip  = "1.2.3.4"
      @gandi_domain.handler.expects(:call).with("host_create", @session_id, @sample_domain_name, [ip]).returns(rand(9000))
      
      assert @gandi_domain.host_create(@sample_domain_name, ip).is_a? Integer
    end
    
    should "delete a host" do
      @gandi_domain.handler.expects(:call).with("host_delete", @session_id, @sample_domain_name).returns(rand(9000))
      
      assert @gandi_domain.host_delete(@sample_domain_name).is_a? Integer
    end
    
    
    should "list redirections for a domain" do
      redirections = [{"type" => "http302", "from" => "w3.example.net", "to" => "http://www.example.net"}]
      @gandi_domain.handler.expects(:call).with("domain_web_redir_list", @session_id, @sample_domain_name).returns(redirections)
      
      assert_equal redirections, @gandi_domain.domain_web_redir_list(@sample_domain_name)
    end
    
    should "check redirection type when adding a redirection for a domain" do
      destination_url = "http://www.example.net"
      
      calls = states('calls').starts_as('none')
      @gandi_domain.handler.expects(:call).with("domain_web_redir_add", @session_id, @sample_domain_name, destination_url, 'http302').returns(rand(9000)).when(calls.is('none')).then(calls.is('first'))
      @gandi_domain.handler.expects(:call).with("domain_web_redir_add", @session_id, @sample_domain_name, destination_url, 'http301').returns(rand(9000)).when(calls.is('first')).then(calls.is('second'))
      @gandi_domain.handler.expects(:call).with("domain_web_redir_add", @session_id, @sample_domain_name, destination_url, 'cloak').returns(rand(9000)).when(calls.is('second'))
      
      Gandi::DomainModules::Redirection::DOMAIN_WEB_REDIR_REDIRECTION_TYPES.each do |type|
        assert @gandi_domain.domain_web_redir_add(@sample_domain_name, destination_url, type).is_a? Integer
      end
      
      assert_raise ArgumentError do
        @gandi_domain.domain_web_redir_add(@sample_domain_name, destination_url, 'bad')
      end
    end
    
    should "delete the redirection on a fqdn" do
      @gandi_domain.handler.expects(:call).with("domain_web_redir_del", @session_id, 'w3.example.net').returns(rand(9000))
      
      assert @gandi_domain.domain_web_redir_del('w3.example.net').is_a? Integer
    end
    
    
    should "create a contact" do
      contact_class, firstname, lastname, address, zipcode, city, country, phone, email = 'individual', 'John', 'Doe', '24 Rue du Pont', '13000', 'Mars', 'France', '+33491909090', 'john@doe.com'
      @gandi_domain.handler.expects(:call).with("contact_create", @session_id, contact_class, firstname, lastname, address, zipcode, city, country, phone, email).returns('XXXZZ-Gandi')
      
      assert_match /.+-Gandi/, @gandi_domain.contact_create(contact_class, firstname, lastname, address, zipcode, city, country, phone, email)
    end
    
    should "update a contact" do
      handle = 'XXXYY-Gandi'
      params = {}
      @gandi_domain.handler.expects(:call).with("contact_update", @session_id, handle, params).returns(rand(9000))
        
      assert @gandi_domain.contact_update(handle, params).is_a? Integer
    end
    
    should "delete a contact" do
      handle = 'XXXYY-Gandi'
      @gandi_domain.handler.expects(:call).with("contact_del", @session_id, handle).returns(rand(9000))
        
      assert @gandi_domain.contact_del(handle).is_a? Integer
    end
    
    should "retrieve infos on a contact" do
      handle = 'XXXYY-Gandi'
      infos = {}
      @gandi_domain.handler.expects(:call).with("contact_info", @session_id, handle).returns(infos)
        
      assert @gandi_domain.contact_info(handle).is_a? Hash
    end
    
    
    should "list operations" do
      operations = [5555, 5642, 6213]
      @gandi_domain.handler.expects(:call).with("operation_list", @session_id).returns(operations)
      
      assert_equal operations, @gandi_domain.operation_list()
    end
    
    should "list pending operations with a filter" do
      operations = [5555]
      filter = {'state' => 'PENDING'}
      @gandi_domain.handler.expects(:call).with("operation_list", @session_id, filter).returns(operations)
      
      assert_equal operations, @gandi_domain.operation_list(filter)
    end
    
    should "get operation details" do
      opid = 5555
      details = {}
      @gandi_domain.handler.expects(:call).with("operation_details", @session_id, opid).returns(details)
      
      assert @gandi_domain.operation_details(opid).is_a? Hash
    end
    
    should "relaunch an operation" do
      opid = 5555
      param = {'authcode' => 'xxxyyyzzz'}
      @gandi_domain.handler.expects(:call).with("operation_relaunch", @session_id, opid, param).returns(true)
      
      assert @gandi_domain.operation_relaunch(opid, param)
    end
    
    should "cancel an operation" do
      opid = 5555
      @gandi_domain.handler.expects(:call).with("operation_cancel", @session_id, opid).returns(true)
      
      assert @gandi_domain.operation_cancel(opid)
    end
  end
end
