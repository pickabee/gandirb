module Gandi
  class Domain < Gandi::Base
    URL = "https://api.gandi.net/xmlrpc/"
    TEST_URL = "https://api.ote.gandi.net/xmlrpc/"
    
    define_getter("domain_list")
    
    def domain_available(domains)
      call('domain_available', domains)
    end
    
    %w(domain_lock domain_unlock domain_info domain_del).each do |domain_method|
      class_eval %Q{
        def #{domain_method}(domain)
          call('#{domain_method}', domain)
        end
      }
    end
    
    %w(domain_renew domain_create domain_restore  domain_transfer_in_available domain_transfer_in domain_transfer_out domain_trade domain_change_owner domain_change_contact).each do |method|
      class_eval %Q{
        def #{method}(*args)
          call('#{method}', *args)
        end
      }
    end
    
  end
end
