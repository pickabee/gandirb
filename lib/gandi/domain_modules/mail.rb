module Gandi
  module DomainModules
    module Mail

      #Enables the Gandimail service for one domain
      def domain_gandimail_activate(domain)
        call('domain_gandimail_activate', domain)
      end

      #Disables the Gandimail service for one domain: mail servers won't accept mail sent to this domain anymore
      #Does not delete forwards, aliases or mailboxes
      def domain_gandimail_deactivate(domain)
        call('domain_gandimail_deactivate', domain)
      end

      #Returns a structure associating each forward with its destinations
      def domain_forward_list(domain)
        call('domain_forward_list', domain)
      end

      #Setup a forward to redirect to one or more destinations. 
      #Warning: it overwrites the forward (the source), so if you try to add one destination to a forward, you shall include the existing destinations
      #TODO: keep existing forwards ?
      def domain_forward_set(domain, source, destinations)
        call('domain_forward_set', domain, source, destinations)
      end

      #Deletes a forward. This does the same thing as domain_forward_set(domain, [])
      def domain_forward_delete(domain, source)
        call('domain_forward_delete', domain, source)
      end

      #Return the list of mailboxes associated with a domain
      def domain_mailbox_list(domain)
        call('domain_mailbox_list', domain)
      end

      #Provides information about a mailbox
      def domain_mailbox_info(domain, mailbox)
        call('domain_mailbox_info', domain, mailbox)
      end

      #Creates a new mailbox
      #Accepted options:
      #  integer quota
      #  boolean antivirus
      #  boolean antispam
      #  string fallback_email
      def domain_mailbox_add(domain, mailbox, password, options = {})
        call('domain_mailbox_add', domain, mailbox, password, options)
      end

      #Updates an existing mailbox
      #Accepted options are the same as the ones for domain_mailbox_add, with password added
      def domain_mailbox_update(domain, mailbox, options)
        call('domain_mailbox_update', domain, mailbox, options)
      end

      #Deletes a mailbox
      def domain_mailbox_delete(domain, mailbox)
        call('domain_mailbox_delete', domain, mailbox)
      end

      #List the aliases of a mailbox
      def domain_mailbox_alias_list(domain, mailbox)
        call('domain_mailbox_alias_list', domain, mailbox)
      end

      #Affect aliases to a mailbox
      def domain_mailbox_alias_set(domain, mailbox, aliases)
        call('domain_mailbox_alias_set', domain, mailbox, aliases)
      end

      #Delete all messages from a mailbox
      def domain_mailbox_purge(domain, mailbox)
        call('domain_mailbox_purge', domain, mailbox)
      end
    end
  end
end
