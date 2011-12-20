#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'bluevia/messaging'
require 'bluevia/schemas/sms_types'

module Bluevia
  #
  # This class is in charge of access Bluevia SMS API
  #

  class Sms < BaseClient
    include Messaging

    include Schemas::Sms_types

    # Basepath for SMS API
    BASEPATH_API = "/SMS"

    def initialize(params = nil)
      super(params)
      #super.extend(Schemas::Sms_types)
    end

    # 
    # This method sends a SMS to a list of destination numbers.
    # [*dest_number*] array, fixnum or string with the destination numbers
    # [*origin*] originator number the SMS will be send in name of. Should be a
    # valid access_token.
    # [*text*] short message text
    # returns the location where the delivery status can be checked
    # 
    def send(dest_number, text, endpoint = nil, correlator = nil)
      Utils.check_attribute dest_number, "Destination number cannot be null"
      Utils.check_attribute text, "SMS text cannot be null"

#      if origin.nil?
        origin = @token        
#      end
      # Set destination array
      @dest_phones = Array.new
      if (dest_number.instance_of?(Array))
        dest_number.each { |i|
          @dest_phones << UserIdType.new(i, nil, nil, nil, nil)
        }
      else
        @dest_phones << UserIdType.new(dest_number, nil, nil, nil, nil)
      end

      @orig = UserIdType.new(nil, nil, nil, origin, nil)

      unless endpoint.nil?
        @simple_reference = SimpleReferenceType.new(endpoint, correlator)
      else
        @simple_reference = nil
      end

      # Create Message and convert to JSON
      @msg = SMSTextType.new(@dest_phones, text, @simple_reference, @orig, nil, nil, nil, nil, nil)
      message = Utils.object_to_json(@msg)

      logger.debug "SMS Send this message:"
      logger.debug message << "\n"

      POST("#{get_basepath}/outbound/requests", message.to_s, nil, nil, "location")
    end

    #
    # This method is used to retrieve MO messages that belongs to a specific registration ID
    # [*registration_id*] MO Registration Identifier Mandatory
    # returns a collection of messages
    #
    def get_received_sms(registration_id)
      response = get_received_message(registration_id)
      key = "receivedSMS"

      # Fetch ["receivedSMS"]["receivedSMS"]
      unless response.nil?
        if response.respond_to?(:has_key?) && response.has_key?(key)
          response = response[key]
          if response.respond_to?(:has_key?) && response.has_key?(key)
            return response[key]
          else
            return Hash.new
          end
        else
          return Hash.new
        end
      else
        return Hash.new
      end
      
    end

    # 
    # Send a startSMSNotification request to the endpoint
    # [*destination*] destination number
    # [*endpoint*] endpoint (basically an owned HTTP server) to deliver SMS notification
    # [*correlator*] unique identifier
    # [*criteria*] Text to match in order to determine the application that shall receive the notification.
    #  This text is matched against the first word in the message.
    # returns the location where the notification can be checked
    # 
    def start_sms_notification(destination, endpoint, correlator, criteria)
      Utils.check_attribute(destination, "Destination number cannot be null")
      Utils.check_attribute(endpoint, "End point to deliver notification must be provided")
      Utils.check_attribute(correlator, "Correlator of request to start in mandatory")
      Utils.check_attribute(criteria, "Filter criteria is mandatory")

      @notif = SMSNotificationType.new(
        SimpleReferenceType.new(endpoint, correlator),
        [UserIdType.new(destination, nil, nil, nil, nil)],
        criteria)

      message = Utils.object_to_json(@notif)
      logger.debug "Message ready to send"
      logger.debug message

      POST("#{get_basepath}/inbound/subscriptions", message.to_s, nil, nil, "location")
    end

    #
    # This method stop the message notification (MO)
    # [*subscription_id*] The subscription identifier to be deleted
    #
    def stop_sms_notification(subscription_id)
      stop_message_notification(subscription_id)
    end

  end
end
