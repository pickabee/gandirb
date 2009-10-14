module Gandi
  module DomainModules
    module Host
      #Returns the array of glue records for the specified domain.
      def host_list(domain)
        call('host_list', domain)
      end
      
      #Retrieve an array of the IP addresses linked to this hostname.
      def host_info(fqdn)
        call('host_info', fqdn)
      end
      
      #Create a glue record with the specified IP addresses.
      #This implementation does not respect the original API specifications and allow for a single IP to be provided.
      #An array of IPs can be provided but only the first IP is used (this is an API limitation).
      #Return the operation attributed ID
      def host_create(host, ip)
        call('host_create', host, [ip].flatten)
      end
      
      #Delete a host.
      #Return the operation attributed ID
      def host_delete(host)
        call('host_delete', host)
      end
    end
  end
end
