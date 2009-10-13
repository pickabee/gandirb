module Gandi
  class Domain < Gandi::Base
    URL = "https://api.gandi.net/xmlrpc/"
    TEST_URL = "https://api.ote.gandi.net/xmlrpc/"
    
    #Returns an array of domains for which the logged user is the reseller or a contact (owner, administrative, billing or technical).
    #TODO: memoize results 
    def domain_list
      call('domain_list')
    end
    
    #Check a domain availability.
    #This implementation does not respect the original API specifications and allow for a single domain to be checked.
    #In this case the domain can be provided as a string and a boolean will be returned.
    def domain_available(domains)
      available_domains = call('domain_available', domains.to_a)
      return (domains.is_a?(String)) ? available_domains.values.first : available_domains
    end
    
    #Add a lock status (cf. domain_info) to avoid any fraudulent transfer.
    #Return the operation attributed ID
    def domain_lock(domain)
      call('domain_lock', domain)
    end
    
    #Remove a lock status (cf. domain_info) to transfer the domain to another registrar.
    #Return the operation attributed ID
    def domain_unlock(domain)
      call('domain_unlock', domain)
    end
    
    #Retrieve the informations linked to this domain (contacts, nameservers, redirections, weblogs…). 
    #This method only works on domains handled by Gandi.
    #Return a hash with string keys containing domain informations (see API documentation)
    #TODO: convert XMLRPC datetimes ?
    def domain_info(domain)
      call('domain_info', domain)
    end
    
    #Renew a domain for a number of years.
    #The total number of years cannot exceed 10.
    #Return the operation attributed ID
    def domain_renew(domain, period)
      raise ArgumentError.new("The total number of years cannot exceed 10") if period > 10
      call('domain_renew', domain, period)
    end
    
    #Register a domain with Gandi and associate it to a list of contacts.
    #Return the operation attributed ID
    def domain_create(domain, period, owner_handle, admin_handle, tech_handle, billing_handle, nameservers, lang = nil)
      call('domain_create', domain, period, owner_handle, admin_handle, tech_handle, billing_handle, nameservers, lang)
    end
    
    #Get a domain out of its redemption period. See glossary, Restore.
    #This function is available for domains in .COM, .NET, .BE or .EU.
    #Return the operation attributed ID
    #TODO: Check for domain correctness
    def domain_restore(domain)
      call('domain_restore', domain)
    end
    
    #Delete a domain.
    #Return the operation attributed ID
    #This method is not available yet and will be present in v1.10 of the API
    def domain_del(domain)
      not_supported
    end
    
    #Check if a domain can be transfered from another registrar. See glossary, Transfer.
    def domain_transfer_in_available(domain)
      call('domain_transfer_in_available', domain)
    end
    
    alias_method :domain_transfer_in_available?, :domain_transfer_in_available
    
    #Transfer (see glossary, Transfer) a domain from another registrar to Gandi, or from a Gandi account to a Gandi reseller. 
    #If the domain is already at Gandi (internal transfer), owner_handle, admin_handle, tech_handle and billing_handle are maintained.
    #Return the operation attributed ID
    def domain_transfer_in(domain, owner_handle, admin_handle, tech_handle, billing_handle, nameservers, auth_code = nil)
      call('domain_transfer_in', domain, owner_handle, admin_handle, tech_handle, billing_handle, nameservers, auth_code)
    end
    
    #Accept or deny a transfer of a domain from Gandi to another registrar. See glossary, Transfer.
    #This method is not available yet and will be present in v1.10 of the API
    def domain_transfer_out(opid, allow)
      not_supported
    end
    
    #Start the trade of a domain from another registrar to Gandi.
    #Return the operation attributed ID
    #This method is not available yet and will be present in v1.10 of the API
    def domain_trade(domain, owner_handle, admin_handle, tech_handle, billing_handle, afnic_titularkey = nil)
      not_supported
    end
    
    #Change the owner of a domain registered with Gandi and, optionally, the admin, tech and billing contacts. See glossary, Change of Ownership.
    #Return the operation attributed ID
    #This method is not available yet and will be present in v1.10 of the API
    def domain_change_owner(domain, new_owner, new_admin = nil, new_tech = nil, new_billing = nil)
      not_supported
    end
    
    #Change a given contact of a domain registered with Gandi.
    #Return the operation attributed ID
    def domain_change_contact(domain, type, new_contact)
      call('domain_change_contact', domain, type, new_contact)
    end
    
  end
end
