#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/clients/commons/bv_mo_client'

module Bluevia
  
  class BVMoSmsClient < BVMoClient
    

    # This method retrieves the list of received SMS belonging to a specific registration ID. 
    # 
    # required params :
    # [*registration_id*] Bluevia short number for your country, including the country code without the + symbol
    #
    # returns nil or an array with a Bluevia::Schemas::SmsMessage object for every message
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_all_messages("34217040")
    #

    def get_all_messages(registration_id)
      
      response = get_messages(registration_id, nil, nil, nil)
      filter_response(response)
      
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
      
      aux = super(destination, endpoint, criteria, correlator)
      
      message = {:smsNotification => aux}

      response = base_create(MS_IN + MS_SUBS, nil, message, nil)
      
      if response.eql?"" or response.nil?
        location =  Utils.filter_header(@Ir, 'location')
        unless location.nil? 
          return location.gsub(/^.+\/subscriptions\/([^\/]+)/, '\1')
        end
      end
      
      e = response.new
      e.code = COD_12
      e.message = ERR_PART3 + "start sms notification."
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
    # Auxiliary method for get_all_messages that filters response to 
    # fill SmsMessage array and returns it. If response was empty then
    # nil is returned. 
    # Returns BlueviaError if filtering was unsuccessfull. 
    #
  
    def filter_response(response)
      begin
        return nil if response.nil? or !response.instance_of?(Hash)
        result = Array.new
        
        unless response.has_key? :receivedSMS
          smss = response['receivedSMS']
          unless smss.has_key? :receivedSMS
            smss = smss['receivedSMS']
          end
        else
          return SmsMessage.new
        end        
        
        if smss.instance_of?(Array)
          smss.each{|sms|
            result << assign_item(sms)
          }
        else
          result << assign_item(smss)
        end
        result
        
      rescue StandardError => error
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "create SmsMessage."
        raise BlueviaError.new(e)
      end
    end
    
    #
    # For every sms this method maps response's elements to SmsMessage attributes,
    #
    
    def assign_item(smss)
      
        item = SmsMessage.new
        item.message = smss['message']
        item.date = smss ['dateTime']
        item.origin_address = get_phone_alias(smss, 'originAddress')
        
        if smss['destinationAddress'].instance_of?Array
          smss['destinationAddress'].each{
             item.destination << get_phone_alias(smss, 'destinationAddress')
             }
        else
          item.destination = get_phone_alias(smss, 'destinationAddress')
        end
        
        
      item
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
    # This method sets parser and serializer for SMS MO client.
    # It also complete Rest part of the URL.
    #
    
    def init
      @Ip = Bluevia::IParser::JsonParser.new
      @Is = Bluevia::ISerializer::JsonSerializer.new
      is_rest
    end
  end

end
