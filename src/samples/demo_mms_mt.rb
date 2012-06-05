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

class DemoMmsMt 
  include Bluevia

  begin
    
    consumer_key= "vw12012654505986"
    consumer_secret= "WpOl66570544"
    mode= BVMode::SANDBOX
    token= "ad3f0f598ffbc660fbad9035122eae74"
    token_secret= "4340b28da39ec36acb4a205d3955a853"
    
    # To create Bluevia client
    @bc = BVMtMms.new(mode, consumer_key, consumer_secret, token, token_secret)
        
    # A set of params
    filepathmms         = "./Movistar_tune.mp3"
    mimetypemms         = "audio/mp3"
     
    # To get absolute pathname 
    filepathmms= File.expand_path(filepathmms)
    
    attach = Array.new
    attach << Bluevia::Schemas::Attachment.new(
      filepathmms,
      mimetypemms
    )
    
    # Sandbox environment only complains about this param if it's a known short number
    mms_special_number  =  "1234"  
    
    body = "The Bluevia APIs make it easy for your application to access our network services."
    subject = "SANDBLUEDEMOS"
  
    # Message sending
    infomms = @bc.send(mms_special_number, subject, body, attach)
    puts "Info returned from 'send' command: " + infomms
    
    # To get delivery status of the message
    infosent = @bc.get_delivery_status(infomms)
    puts "Info returned from 'get_delivery_status' command: "
    
    puts infosent.inspect
    
    puts infosent[0].status
    puts infosent[0].status_description
    
  rescue StandardError => e
    puts "received Exception: #{e}"
  end
end

