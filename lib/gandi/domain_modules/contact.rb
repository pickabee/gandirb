module Gandi
  module DomainModules
    module Contact
      CONTACT_CLASSES = ['individual', 'company', 'public', 'association']
      
      #Create a Gandi contact of a given type. See glossary, Account.
      #Return the Gandi handle of the created contact
      #Note: contact_class argument is used instead of class (due to a ruby keyword conflict)
      #TODO check contact class
      def contact_create(contact_class, firstname, lastname, address, zipcode, city, country, phone, email, params = {})
        args = [contact_class, firstname, lastname, address, zipcode, city, country, phone, email, params]
        args.pop if params.empty?
        
        call('contact_create', *args)
      end
      
      #Update a Gandi contact
      #Return the operation attributed ID
      #TODO: check for frozen params
      def contact_update(handle, params)
        call('contact_update', handle, params)
      end
      
      #Delete a Gandi contact
      #Return the operation attributed ID
      def contact_del(handle)
        call('contact_del', handle)
      end
      
      #Retrieve a hash of Gandi contact informations
      def contact_info(handle)
        call('contact_info', handle)
      end
    end
  end
end
