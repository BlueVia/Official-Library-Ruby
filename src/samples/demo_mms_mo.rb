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

class DemoMmsMo 
  
  include Bluevia
  include Bluevia::Schemas

  # This demo shows how to use sandbox fake mo messages
  # send() function will only for long numbers in LIVE mode

  begin

    consumer_key= "vw12012654505986"
    consumer_secret= "WpOl66570544"
    mode= BVMode::SANDBOX
    token= "ad3f0f598ffbc660fbad9035122eae74"
    token_secret= "4340b28da39ec36acb4a205d3955a853"
    
    # To create Bluevia client
    @mt = BVMtMms.new(mode, consumer_key, consumer_secret, token, token_secret)

    # A set of params 
    # Please, note short number for fake mo messages 
    # and the need for absolute path in attachment file information
    filepathmms         = "./Movistar_tune.mp3"
    mimetypemms         = "audio/mp3"
     
    filepathmms= File.expand_path(filepathmms)
    attach = Array.new
    
    attach << Attachment.new(
      filepathmms,
      mimetypemms
    )
    
    mms_special_number  =  "546780" 
    body = "The Bluevia APIs make it easy for your application to access our network services."
    subject = "SANDBLUEDEMOS"
    atturl=false #if true, then attachment url will be available in order to get every attachment separately
    
    # Message sending
    infomms = @mt.send(mms_special_number, subject, body, attach)
    p "Info returned from 'send' command: " +infomms

    # For mms MO messages, two legged client for Bluevia is required (as shown below)
    @mo = BVMoMms.new(mode, consumer_key, consumer_secret)
    
    # To retrieve sent messages to the short number
    messages =@mo.get_all_messages(mms_special_number, atturl)  
    p "Message retrieved: " + messages.inspect
    
    message_id = Array.new  
    messages.each_index{|ind|
    
      message_id << messages[ind].message_id
      received_mms= @mo.get_message(mms_special_number, message_id[ind])
      
      puts received_mms.inspect
      
      attachments_mes = received_mms.attachments
      attachments_mes.each_index{|file_att|
        p attachments_mes[file_att].content_type
        f_at= File.new("attachment#{file_att}", "w")
        f_at.write(attachments_mes[file_att].content)
        f_at.close
        }
      
      # send with use_attachment_id "true" doesn't work for SANDBOX mode
      # see below snipper for retrieving every attachment from a message separately
 
      #  attachment_array = message.attachment_URLs
      #  attachment_array.each{|attach|
      #  attach_url=attach.url
      #  attach_ctype = attach.content_type
        
      #  attachment=@bc.get_attachment(registration_id, message_id, attach_url)
      #  }
      }
           
  rescue StandardError => e
    puts "received Exception: #{e}"
  end
end
