#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bluevia'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#
# (c) Bluevia (mailto:support@bluevia.com)
#

class DemoSmsMt

  include Bluevia
  
  begin
    
    consumer_key= "vw12012654505986"
    consumer_secret= "WpOl66570544"
    mode= BVMode::SANDBOX
    token= "ad3f0f598ffbc660fbad9035122eae74"
    token_secret= "4340b28da39ec36acb4a205d3955a853"
    
    # To create Bluevia client
    @bc = BVMtSms.new(mode, consumer_key, consumer_secret, token, token_secret)
        
    # Sandbox environment only complains about this param if it's a known short number
    short_number  = "1234" 
    sms_special_keyword = "SANDBLUEDEMOS"
    sms_content= "The Bluevia APIs make it easy for your application to access our network services."
  
    # Message sending
    message_id =  @bc.send(short_number, "#{sms_special_keyword} #{sms_content}")
    p "Info returned from 'send' command: " + message_id
    
    # To get delivery status of the message
    infostatus = @bc.get_delivery_status(message_id)
    
    puts infostatus.inspect
    
  rescue StandardError => e
    puts "received Exception: #{e}" #do whatever
  end

end
