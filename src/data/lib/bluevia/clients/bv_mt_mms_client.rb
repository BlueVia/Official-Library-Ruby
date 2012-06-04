#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


require 'rack'
require 'bluevia/clients/commons/bv_mt_client'
require 'bluevia/serializers/multipart_serializer'

module Bluevia
  
  class BVMtMmsClient < BVMtClient
    
    #
    # Allows to know the delivery status of a previous sent message using Bluevia API
    # 
    # required params :
    # [*message_id*] ID of the message previously sent using this API
    #
    # returns an array full of Bluevia::Schemas::DeliveryInfo object with information about MMS status
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
    # 
    # required params :
    # [*destination*]     Array, fixnum or string with the destination numbers
    # [*subject*]         Subject for the multimedia message
    # optional params :
    # [*origin_address*]  Phone number or alias of the sender
    # [*message*]         Text message of the MMS
    # [*attachment*]      Multimedia file to send. 
    # [*sender_name*]     It indicates a human-readable text for mms remitent
    # [*payer*]           If not indicated, API payer is MSISDN sender of MMS
    # [*endpoint*]        Endpoint to receive notifications of sent MMSs
    # [*correlator*]      Correlator to receive notifications of sent MMSs
    #
    # returns a String containing the id of the MMS sent
    # raise BlueviaError when things went wrong
    #

    def send(destination, subject, origin_address = nil, message = nil, attachment = nil, sender_name = nil, payer = nil, endpoint = nil, correlator = nil)
      Utils.check_attribute(subject, ERR_PART1 + " 'subject' " + ERR_PART2)
      
      headers = nil
      
      unless payer.nil? and origin_address.nil?
        if payer.nil?
          headers = get_headers(origin_address)
        else
          headers = get_headers(payer)
        end
      end
      
      aux = super(destination, origin_address, sender_name, endpoint, correlator)  
      
      aux[:subject] = subject
      
      # Create Message and convert to JSON
      msg = {:message=> aux}
      
      logger.debug "MMS Send this message:"
      logger.debug msg.to_s
      
      # MMS special serializer: message, body, attachment
      mms_serializer ={:message => msg, :body=> message, :attachment=> attachment} 
      
      response = base_create(MS_OUT, nil, mms_serializer, headers)
          
      unless response.nil?
        
        return filter_send
        
      else
        e = BVResponse.new
        e.code = BVEXCEPTS[ERR_CON]
        e.message = ERR_CON
        raise BlueviaError.new(e)
      end
      
    end
    
    #
    # Auxiliary method for get_delivery_status that filters response to 
    # fill DeliveryInfo array and returns it. If response was empty then nil is returned. 
    # Returns BlueviaError if filtering was unsuccessfull. 
    #
    def filter_response(response)
      
      return nil if response.nil? or !response.instance_of?(Hash)
      result = Array.new
      
      unless response.has_key? :messageDeliveryStatus
        advs = response['messageDeliveryStatus']
        unless advs.has_key? :messageDeliveryStatus
          advs = advs['messageDeliveryStatus']
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
    end
    
    #
    # For every mms this method maps response's elements to DeliveryInfo attributes,
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
      init
    
    end
    
    def init_trusted(mode, consumer_key, consumer_secret, cert_file, cert_pass)
      
      super
      init

    end

    #
    # This method sets parser and serializer for MMS MT client
    # It also complete Rest part of the URL
    #
    def init
      @Ip = Bluevia::IParser::JsonParser.new
      @Is = Bluevia::ISerializer::MultipartSerializer.new
      is_rest
    end
  end
  
end
