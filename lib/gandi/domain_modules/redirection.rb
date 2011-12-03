module Gandi
  module DomainModules
    module Redirection
      DOMAIN_WEB_REDIR_REDIRECTION_TYPES = ['http302', 'http301', 'cloak']
      
      #Retrieve an array of web redirections for a domain
      def domain_web_redir_list(domain)
        call('domain_web_redir_list', domain)
      end
      
      #Add a web redirection to a domain. All HTTP requests to http://fqdn/ will be redirected to 'destination_url' with a HTTP redirection 'type'
      #Return the operation attributed ID
      def domain_web_redir_add(fqdn, destination_url, type)
        raise ArgumentError.new("Redirection type is invalid") unless DOMAIN_WEB_REDIR_REDIRECTION_TYPES.include?(type)
        call('domain_web_redir_add', fqdn, destination_url, type)
      end
      
      #Delete the web redirection of the fully qualified domain name fqdn
      #Return the operation attributed ID
      def domain_web_redir_del(fqdn)
        call('domain_web_redir_del', fqdn)
      end
    end
  end
end
