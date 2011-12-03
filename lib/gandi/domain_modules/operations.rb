module Gandi
  module DomainModules
    module Operations
      #Retrieve an array of the last 300 operation IDs matching the optional criterias
      def operation_list(filter = {})
        unless filter.empty?
          call('operation_list', filter)
        else
          call('operation_list')
        end
      end
      
      #Retrieve an operation details
      def operation_details(opid)
        call('operation_details', opid)
      end
      
      #Relaunch an operation, modifying the given parameters
      #TODO: check param
      def operation_relaunch(opid, param)
        call('operation_relaunch', opid, param)
      end
      
      #Cancel an operation
      def operation_cancel(opid)
        call('operation_cancel', opid)
      end
    end
  end
end
