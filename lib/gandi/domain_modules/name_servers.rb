module Gandi
  module DomainModules
    module NameServers
      
      #Retrieve an array of name servers for a domain
      def domain_ns_list(domain)
        call('domain_ns_list', domain)
      end
      
      #Add the specified name servers to the name servers list of a domain
      #Return the operation attributed ID 
      def domain_ns_add(domain, ns_list)
        call('domain_ns_add', domain, ns_list)
      end
      
      #Remove the specified name servers from the name servers list of a domain
      #Return the operation attributed ID
      def domain_ns_del(domain, ns_list)
        call('domain_ns_del', domain, ns_list)
      end
      
      #Set a domain name servers list
      #Return the operation attributed ID
      def domain_ns_set(domain, ns_list)
        call('domain_ns_set', domain, ns_list)
      end
    end
  end
end
