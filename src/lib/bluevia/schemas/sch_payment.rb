#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module Schemas
  
    #
    # PaymentStatus object for payment Client
    # attributes:
    # [*transaction_status*] Actual status of the payment transaction 
    # [*transaction_status_description*] Short explanation about status code 
    #
    
    class PaymentStatus 
      attr_accessor :transaction_status, :transaction_status_description
      
      def initialize (transaction_status = nil, transaction_status_description = nil)
        @transaction_status = transaction_status
        @transaction_status_description = transaction_status_description
      end   
    end
    
    #
    # PaymentResult object for payment Client 
    # attributes:
    # [*transaction_id*] Transaction id of the payment transaction 
    # [*transaction_status*] Actual status of the payment transaction 
    # [*transaction_status_description*] Short explanation about status code 
    #
    
    class PaymentResult < PaymentStatus
      attr_accessor :transaction_id
      def initialize (transaction_id = nil, payment_status = nil)
        @transaction_id = transaction_id
        @transaction_status = payment_status.transaction_status
        @transaction_status_description = payment_status.transaction_status_description
      end
    end
  
  end
end