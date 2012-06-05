#encoding: utf-8
#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bluevia'

#
# (c) Bluevia (mailto:support@bluevia.com)
#

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class DemoSmsMo 

 include Bluevia
 
 # This demo shows how to use sandbox fake mo messages
 # send() function will only for long numbers in LIVE mode
 
  begin
    
    consumer_key= "vw12012654505986"
    consumer_secret= "WpOl66570544"
    mode= BVMode::SANDBOX
    token= "ad3f0f598ffbc660fbad9035122eae74"
    token_secret= "4340b28da39ec36acb4a205d3955a853"
    
    # To create BVMoSms client
    @mt = BVMtSms.new(mode, consumer_key, consumer_secret, token, token_secret)
        
    # A set of params (note short number for fake mo messages)
    short_number  = "546780" 
    sms_special_keyword = "SANDBLUEDEMOS"
    sms_content= "The Bluevia APIs make it easy for your application to access our network services."
  
    # Message sending
    infosms= @mt.send(short_number, "#{sms_special_keyword} #{sms_content}")
    
    p "Info returned from 'send' command: " + infosms
    
    # For sms MO messages, two legged client for Bluevia is required (as shown below)
    @mo = BVMoSms.new(mode, consumer_key, consumer_secret)
        
    # To retrieve sent messages to the short number
    ans = @mo.get_all_messages(short_number)
    puts "Message retrieved: " 
    puts ans.inspect
       
  rescue StandardError => e
    puts "received Exception: #{e}" # do whatever
  end

end
