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
  end
  
  
end
