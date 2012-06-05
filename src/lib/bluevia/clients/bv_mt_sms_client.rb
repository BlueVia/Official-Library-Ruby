#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/clients/commons/bv_mt_client'


module Bluevia
  
  class BVMtSmsClient < BVMtClient

    #
    # Allows to know the delivery status of a previous sent message using Bluevia API
    # 
    # required params :
    # [*message_id*] ID of the message previously sent using this API
    #
    # returns a Bluevia::Schemas::DeliveryInfo object with information about SMS status
    # or nil if response was empty.
    #
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_delivery_status("123456789_id")
    #
    
    def get_delivery_status (message_id)
    
      response = super(message_id)
      filter_response(response)
      
    end
    
    private
    
    #
    # Axiliary method user from public send methods from trusted and untrusted.    
    # required params :
    # [*destination*]     Array, fixnum or string with the destination numbers
    # [*text*]            Text message of the SMS
    # optional params :      
    # [*origin_address*]  Phone number or alias of the sender
    # [*sender_name*]     It indicates a human-readable text for SMS remitent
    # [*payer*]           If not indicated, API payer is MSISDN sender of SMS
    # [*endpoint*]        Endpoint to receive notifications of sent SMSs
    # [*correlator*]      Correlator to receive notifications of sent SMSs
    #
    # returns a String containing the id of the SMS sent.
    # raise BlueviaError 
    #
    
    def send(destination, text, origin_address = nil, sender_name = nil, payer = nil, endpoint = nil, correlator = nil)
      
      Utils.check_attribute text, ERR_PART1 + " 'text' " + ERR_PART2
      
      headers = nil
      
      unless payer.nil?
          headers = get_headers(payer)
      end
      
      
      aux = super(destination, origin_address, sender_name, endpoint, correlator)
      
      aux[:message] = text
      
      msg = {:smsText=> aux}
      
      logger.debug "SMS Send this message:"
      logger.debug msg.to_s 
      
      response = base_create(MS_OUT, nil, msg, headers)
      
      unless response.nil? 
        
        return filter_send
        
      else
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "send message"
        raise BlueviaError.new(e)
      end
      
    end
    
    #
    # Auxiliary method for get_delivery_status that filters response to 
    # fill DeliveryInfo array and returns it. If response was empty then nil is returned. 
    # Returns BlueviaError if filtering was unsuccessfull. 
    #    
    
    def filter_response(response)
      
      begin
        return nil if response.nil? or !response.instance_of?(Hash)
        result = Array.new
        
        unless response.has_key? :smsDeliveryStatus
          advs = response['smsDeliveryStatus']
          unless advs.has_key? :smsDeliveryStatus
            advs = advs['smsDeliveryStatus']
          end
        else
          return nil
        end        
        
        if advs.instance_of?(Array)
          advs.each{|adv|
            result << assign_item(adv)
          }
        else
          result << assign_item(advs)
        end
        result
      rescue StandardError => error
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "get delivery status."
      end
    
        
    end

    #
    # For every sms this method maps response's elements to DeliveryInfo attributes.
    # It also fills 'status_description' with a long description message saved in 
    # public BVDELIVERYSTATUS array.
    #
    def assign_item(advs)
      item = DeliveryInfo.new
      item.destination = advs['address']['phoneNumber']
      item.status = advs['deliveryStatus']
      
      if advs.has_key? :description
        item.status_description = advs['deliveryStatus']['description']
      else
        
        BVDELIVERYSTATUS.each{|k,v|
          if item.status.eql? k
            item.status_description = v
          end
        }
          
      end
        
      item
    end
    
    def init_untrusted(mode, consumer_key, consumer_secret, token_key, token_secret)
      
      super
      init_ip_is
      # Completes rest part of the URL      
      is_rest

    end
    def init_trusted(mode, consumer_key, consumer_secret, cert_file, cert_pass)
      
      super
      init_ip_is
      # Completes rest part of the URL
      is_rest

    end
    
    #
    # This method sets parser and serializer for SMS MT client
    #
    
    def init_ip_is
      @Ip = Bluevia::IParser::JsonParser.new
      @Is = Bluevia::ISerializer::JsonSerializer.new
    end
    
  end

end
