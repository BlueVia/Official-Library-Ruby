#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'rack'
require 'bluevia/clients/commons/bv_mo_client'


module Bluevia

  class BVMoMmsClient < BVMoClient

    #
    # Retrieves the list of received MMS. Depending on the value of the use_attachment_id parameter
    # the response will include the IDs of the attachments or not. If ids are retrieved, the function 
    # 'get_attachment' can be used; otherwise, attachments must be obtained with get_message function
    # 
    # required params :
    # [*registration_id*]   MO Registration Identifier (short number for the country)
    # optional params :
    # [*use_attachment_id*] Bool flag to get message attachments information
    #                       It's an optional parameter (false value by default)
    #
    # returns nil or an array with a Bluevia::Schemas::MmsMessageInfo object for every message
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_all_messages("34217040", true)
    #
    
    def get_all_messages(registration_id, use_attachment_id = false)
      
      @Ip = @parser_json
      @Is = @serializer
        
      param={:useAttachmentURLs => use_attachment_id}
      
      response = get_messages(registration_id, nil, nil, param)  
      return filter_response(response)
       
    end
    
    #
    # Gets the content of a message with a 'message_id' sent to the 'registration_id'
    # 
    # required params :
    # [*registration_id*] MO Registration Identifier (short number for the country)
    # [*message_id*]      Message id (obtained with get_all_messages method)
    #
    # returns a Bluevia::Schemas::MmsMessage object including attachments
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_message("34217040", "12341234123412341234")
    #

    def get_message(registration_id, message_id) 
      Utils.check_attribute message_id, ERR_PART1 + " 'message_id' "+ ERR_PART2
      
      # Re-set parser and serializer (multipart needed)
      @Ip = @parser_multipart
      @Is = @serializer
      
      # Calls auxiliary method that complete common parts of the request
      response =  get_messages(registration_id, message_id ,nil, nil)
      
      # Filtering response
      return MmsMessage.new if response.nil? or !response.instance_of?(Array)
      
      result = MmsMessage.new
      message = response[0]['message']
      m_info = MmsMessageInfo.new
      m_info.message_id = message_id
      if message['address'].instance_of?Array
          message['address'].each{
             m_info.destination << get_phone_alias(message, 'address')
             }
        else
          m_info.destination = get_phone_alias(message, 'address')
        end
      
      m_info.origin_address = get_phone_alias(message, 'originAddress')
      m_info.subject =  message['subject']
      
      result.mms_info = m_info
      result.attachments = response[1]
      
      return result
    end
    
    #
    # Gets the attachment with the specified id of the received message.
    # 
    # required params :
    # [*registration_id*] MO Registration Identifier (short number for the country)
    # [*message_id*]      Message id (obtained with get_all_messages method)
    # [*attachment_id*]   Message id (obtained with get_all_messages method)
    #   
    # returns a Bluevia::Schemas::MimeContent object including attachments
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_attachment("34217040", "12341234123412341234", "attachment_1")
    #
    
    def get_attachment(registration_id, message_id, attachment_id)
     
      # Check mandatory parameters (not the common ones)
      Utils.check_attribute message_id, ERR_PART1 + " 'message_id' "+ ERR_PART2
      Utils.check_attribute attachment_id, ERR_PART1 + " 'attachment_id' " + ERR_PART2
      
      # Re-set parser and serializer 
      @Ip = nil
      @Is = @serializer
      
      # Calls auxiliary method that complete common parts of the request
      response =  get_messages(registration_id, message_id, attachment_id, nil)
      unless !response.nil?
        return filter_attachment_response
      else
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "create MimeContent."
        raise BlueviaError.new(e)
      end
     
    end

    # 
    # Sends a start_notification request to the endpoint
    # 
    # required params :
    # [*destination*] destination number
    # [*endpoint*] endpoint (basically an owned HTTP server) to deliver MMS notification
    # [*criteria*] Text to match in order to determine the application that shall receive the notification.
    # optional params :
    # [*correlator*] unique identifier (if not provided, SDK will generate one)
    # 
    # returns location where the notification can be checked
    # raise BlueviaError
    # 
    
    def start_notification(destination, endpoint, criteria, correlator = nil)
      
      # Re-set paraser and serializer
      @Ip = @parser_json
      @Is = @serializer
      
      aux = super(destination, endpoint, criteria, correlator)
      message = {:messageNotification => aux}
        
      response = base_create(MS_IN + MS_SUBS, nil, message, nil)
      
      # Location header contains info about location where the notification will be checked
      if response.eql?"" or response.nil?
        location =  Utils.filter_header(@Ir, 'location')
        unless location.nil? 
          return location.gsub(/^.+\/subscriptions\/([^\/]+)/, '\1')
        end
      end
      e = response.new
      e.code = COD_12
      e.message = ERR_PART3 + "start message notification."
      raise BlueviaError.new(e)
      
    end
    
    # 
    # This method stop message notification (MO)
    # 
    # required params :
    # [*subscription_id*] The subscription identifier to be deleted
    # 
    # returns true when everything was ok
    # raise BlueviaError
    #
    
    def stop_notification(subscription_id)
      super
    end
    
  private

    #
    # Auxiliary method for get_attachment.
    # Fills MimeContent directly from BVBaseClient response's headers and body.
    # Returns BlueviaError when filtering was not successfull.
    #
        
    def filter_attachment_response
      begin
        
        attach_content = MimeContent.new
        
        c_type = Utils.filter_header(@Ir, 'content-type')
        
        if c_type.nil?
          attach_content.name = nil
          attach_content.content_type = nil
        else
          aux = c_type.split(';')
          attach_content.content_type = aux[0]
        
          if c_type.include?('name')
            attach_content.name = aux[1].gsub(/name=/, '')
          else
            attach_content.name = nil
          end
        end
      
        c_transfer_enc = Utils.filter_header(@Ir, 'content-transfer-encoding')
        if c_transfer_enc.nil?
          attach_content.encoding = nil
        else
          attach_content.encoding = c_transfer_enc
        end
        
        attach_content.content = @Ir.additional_data[:body]
        
        return attach_content
        
      rescue StandardError => error
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "create MimeContent."
        raise BlueviaError.new(e)
      end
    
    end
    
    #
    # Auxiliary method for get_all_messages that filters response to 
    # fill MmsMessageInfo array and returns it. If response was empty then
    # nil is returned. 
    # Returns BlueviaError if filtering was unsuccessfull. 
    #
    def filter_response(response)
      begin
        return nil if response.nil? or !response.instance_of?(Hash)
        result = Array.new
        
        unless response.has_key? :receivedMessages
          mmss = response['receivedMessages']
          unless response.has_key? :receivedMessages
            mmss = mmss['receivedMessages']
          end
        else
          return MmsMessageInfo.new
        end        
        
        if mmss.instance_of?(Array)
          mmss.each{|mms|
            result << assign_item(mms)
          }
        else
          result << assign_item(mmss)
        end
        return result
        
      rescue StandardError => error
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "create MmsMessageInfo."
        raise BlueviaError.new(e)
      end
    end
    
    #
    # For every message this method maps response's elements to MmsMessageInfo attributes,
    # if one of response's elements is 'attachmentURL' then calls assign_attach_url method.
    #
    
    def assign_item(mmss)
      
        item = MmsMessageInfo.new
        item.message_id = mmss['messageIdentifier']
        item.subject = mmss['subject']
        item.date = mmss['dateTime']
        item.origin_address = get_phone_alias(mmss, 'originAddress')
        if mmss['destinationAddress'].instance_of?Array
          mmss['destinationAddress'].each{
             item.destination << get_phone_alias(mmss, 'destinationAddress')
             }
        else
          item.destination = get_phone_alias(mmss, 'destinationAddress')
        end
        
        res = Array.new
        
        if mmss['attachmentURL'].instance_of?(Array)
          mmss['attachmentURL'].each{|mms|
            
            res << assign_attach_url(mms)
          }
        else
          
          res << assign_attach_url(mmss['attachmentURL'])
        end
      
      item.attachment_URLs = res
      
      return item
    end
    
    #
    # For every 'attachmentURL' this method maps it to an AttachmentInfo object.
    #
    
    def assign_attach_url(att_url)
      att = AttachmentInfo.new
        
      unless att_url.nil?
        
        att.url = att_url['href']
        att.content_type = att_url['contentType']
        return att
      else
        return att = nil
      end
      
    end
    
    def init_untrusted(mode, consumer_key, consumer_secret, token_key = nil, token_secret = nil)
      
      super
      init

    end
    
    def init_trusted(mode, consumer_key, consumer_secret, cert_file, cert_pass)
      
      super
      init
    end

    #
    # This method sets parser and serializer for MMS MO client
    # It also complete Rest part of the URL
    #
    
    def init
      @parser_json = Bluevia::IParser::JsonParser.new
      @parser_multipart = Bluevia::IParser::MultipartParser.new
      @serializer = Bluevia::ISerializer::JsonSerializer.new
      is_rest
    end
  end
end
