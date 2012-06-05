#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bluevia'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class DemoPayment
  include Bluevia
  
  begin
   
    consumer_key= "xxxxxx"
    consumer_secret= "yyyyyyy"
    mode= BVMode::SANDBOX
    
    # To create BVPayment client
    @bc = BVPayment.new(mode, consumer_key, consumer_secret)
        
    # A set of params
    amount = "177"
    currency="EUR"
    service_name = "xxxxxxxxxx"
    service_id = "xxxxxxxxxx"
    callback = "oob"
    
    # Oauth process special for payment API 
    pay_request_token = @bc.get_payment_request_token(amount, currency, service_name, service_id, callback)
        
    puts "To get access token and secret, we need you to finish the payment authorization process following this url: "+ pay_request_token.auth_url
    puts "Please, introduce the obtained pin code:"
  
    STDOUT.flush  
    pin_code= gets.chomp  
    
    pay_access_token = @bc.get_payment_access_token(pin_code)
    
    puts "Your access token and secret for the selected application are " + pay_access_token.token + " and "+ pay_access_token.secret
    
    # To set payment tokens in the BVPayment Client
    @bc.set_token(pay_access_token)    
    
    # Request for payment
    answer = @bc.payment(amount, currency)
    puts "Payment's answer: " 
    
    # Transaction information
    puts answer.transaction_id
    puts answer.transaction_status
    puts answer.transaction_status_description
    
    # In order to get information about the transaction do as follows.
    ans2 = @bc.get_payment_status(answer.transaction_id)
    p "Result from get_payment_status: " 
    p ans2.inspect
    
    # To cancel payment authorization:
    ans3 = @bc.cancel_authorization()
    p "cancel_authorization returns: " 
    p ans3
  
  rescue StandardError => e
    puts "received Exception: #{e}"
  end
end
