#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

module Bluevia
  #
  # This module is a mixin used by SMS client to get some basic messaging features
  #

  module Messaging


    # Get All Received Messages to a specific shortcode     
    # [*registration_id*] ShortCode
    # returns a collection of messages
    def get_messages(registration_id)
      _get_received_message(registration_id, nil, false)
    end
    
    # Get a specified Received Messages to a specific shortcode     
    # [*registration_id*] ShortCode
    # returns a collection of messages
    def get_message(registration_id, message_id) 
      _get_received_message(registration_id, message_id, false)
    end
    
    
    #
    # This method is used to retrieve MO messages that belongs to a specific registration ID
    # [*registration_id*] MO Registration Identifier Mandatory
    # [*message_id*] message unique identifier (in case of MMS to get aditional info)
    # [*attachment_id*] string flag to get message attachments (if 'all' returns all attachments)
    # returns a collection of messages
    #
    def _get_received_message(registration_id, message_id = nil, attachment_id = false)
      Utils.check_attribute(registration_id, "Provisioning registration id must be provided")
            
      unless message_id.nil?
         message_id = "/#{message_id}"
      else
         message_id = ""  
      end
      
      if attachment_id == 'all'
        attachments = "/attachments"
      elsif !attachment_id.eql?false
        attachments = "/attachments/" + attachment_id.to_s
      else
        attachments = ""
      end
      
      GET("#{get_basepath}/inbound/#{registration_id}/messages#{message_id}#{attachments}")
    end

    #
    # This method returns the delivery status of a SMS sent by the user
    # [*id*] message unique identifier
    #

    def get_delivery_status (id)
      Utils.check_attribute id, "#{self.class.to_s.upcase} identifier cannot be null"
      if is_url?(id)
        id = id.split("/").last(2).first
      end
      response = GET("#{get_basepath}/outbound/requests/#{id}/deliverystatus", nil, nil)

      # Clean duplicated key
      if response.instance_of?(Hash)
        if response.has_key?("smsDeliveryStatus")
          return response["smsDeliveryStatus"]
        elsif response.has_key?("messageDeliveryStatus")
          return response["messageDeliveryStatus"]
        else
          return response
        end
      end
    end

    #
    # This method stop the message notification (MO)
    # [*subscription_id*] The subscription identifier to be deleted
    #

    def stop_message_notification(subscription_id)
      Utils.check_attribute(subscription_id, "Subscription id must be provided")

      DELETE("#{get_basepath}/inbound/subscriptions/#{subscription_id}")
      true
    end

    private
    
    # obtains user structure based on type
     def get_userid_type(type, value)
       case type
       when 'phoneNumber'
         return UserIdType.new(value,nil,nil,nil, nil)
       when 'anyUri'
         return UserIdType.new(nil,value, nil,nil, nil)
       when 'ipAddress'
         return UserIdType.new(nil,nil, value,nil, nil)
       when 'alias'
         UserIdType.new(nil,nil,nil,value,nil)
       when 'otherId'
         UserIdType.new(nil,nil,nil,nil,value)        
       end
     end
       

    #
    # Validates if a URL is defined properly
    #
    def is_url?(identifier)
      if identifier.match(/^https?:\/\//i).nil?
      # if identifier.match(/^https?:\/\/([a-z0-9-]+\.)+[a-z0-9]+(:[0-9]{2,5})?/i)
      #if identifier.match(/^https?:\/\/([a-z]+\.)*[a-z]+$/i).nil?
      #if identifier.match(/^https?:\/\/([a-z]+\.)*[a-z]+$/i).nil?
        return false
      else
        return true
      end
      raise RuntimeError, "Error while executing stop_message_notification. Nil object received"
    end
  end
end
