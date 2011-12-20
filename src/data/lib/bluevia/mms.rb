#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'bluevia/messaging'
require 'bluevia/schemas/mms_types'
require 'rack'

module Rack
 #
 # Code inyection in Rack::Multipart::Parser class, get_data method
 # Normal Rack method does not return the required content_type information
 # when the chunk to parse does not have the filename in the attachments
 # 
  module Multipart
    class Parser
      def get_data(filename, body, content_type, name, head)
 	data = nil
        if filename == ""
          # filename is blank which means no file has been selected
          return data
        elsif filename
          body.rewind

          # Take the basename of the upload's original filename.
          # This handles the full Windows paths given by Internet Explorer
          # (and perhaps other broken user agents) without affecting
          # those which give the lone filename.
          filename = filename.split(/[\/\\]/).last

          data = {:filename => filename, :type => content_type,
                  :name => name, :tempfile => body, :head => head}
        elsif !filename && content_type && body.is_a?(IO)
          body.rewind

          # Generic multipart cases, not coming from a form
          data = {:type => content_type,
                  :name => name, :tempfile => body, :head => head}
	
	elsif !filename && content_type
          data = {:type => content_type,
                  :name => name, :tempfile => body, :head => head}	  
	else
          data = body
        end

        [filename, data]	
      end
    end
  end
end


module Bluevia
  #
  # This class is in charge of access Bluevia MMS API
  #

  class Mms < BaseClient

    include Messaging

    include Schemas::Mms_types

    # Base Path for MMS API
    BASEPATH_API = "/MMS"

    def initialize(params = nil)
      super(params)
    end

    
    #
    # This method sends a MMS to a list of destination numbers.
    #
    # [*dest_number*] array, fixnum or string with the destination numbers
    #
    # [*origin*] originator number the MMS will be send in name of. If empty
    # defaults to authorized access_token. 
    #
    # [*object*] multimedia file to send. Can be either a file URI or a hash
    # containing the key :text with the large text that should be sent.
    #
    # [*body*] The body content of message
    #
    # [*subject*] subject for the multimedia message
    #
    # [*endpoint*] Endpoint & correlator are parameters for implicit message notification
    # [*correlator*]
    #
    # [*get_url*] If true, returns the full URI containing the message notification status
    #
    # Returns the location where the delivery status can be checked
    #
    def send(dest_number, object = nil,  body = nil, subject = nil, endpoint = nil, correlator = nil, get_url = false)
#      if origin.nil?
        origin = @token
#      end
      # Set destination phones
      @dest_phones = Array.new
      if (dest_number.instance_of?(Array))
        dest_number.each { |i|
          @dest_phones << UserIdType.new(i, nil,nil,nil, nil)
        }
      else
        @dest_phones << UserIdType.new(dest_number, nil,nil,nil, nil)
      end

      @orig = UserIdType.new(nil, nil, nil, origin, nil)

      # Set message and convert to JSON
      unless endpoint.nil?
        @receipt_request = SimpleReferenceType.new(endpoint, correlator)
      else
        @receipt_request = nil;
      end
      @msg = MessageType.new(@dest_phones, @receipt_request, nil, @orig, subject)
      message = Utils.object_to_json(@msg)

      response = POST_MULTIPART(
            "#{get_basepath}/outbound/requests",
            message.to_s,
            body,
            object,
            nil,
            "location"
      )
      
      unless response.nil?
        if response.headers.has_key? 'location'
          location = response.headers['location']
          unless get_url
            location.gsub(/^.+\/requests\/([^\/]+)\/deliverystatus/, '\1')
          else
            location.to_s
          end
        else
          raise RuntimeError, "Unable to create MMS #{response.body}"
        end
      else
        raise RuntimeError, "Unable to connect with endpoint."
      end
    end

    #
    # This method is used to retrieve MMS MO messages that belongs to a specific registration ID.
    # It uses the mixin Messaging.
    # [*registration_id*] MO Registration Identifier Mandatory
    # [*message_id*] message unique identifier (in case of MMS to get aditional info)
    # [*attachments*] bool flag to get message attachments (if true)
    # returns a collection of MMS messages
    #
    def get_received_mms(registration_id, message_id = nil, attachments = false)
      response = _get_received_message(registration_id, message_id, attachments)
      # If requesting messages, clean the result
 
      if message_id.nil? and !attachments
        unless response.nil?
          if response.has_key?("receivedMessages") && !response["receivedMessages"].nil? && response["receivedMessages"].has_key?("receivedMessages")
            response["receivedMessages"]["receivedMessages"]
          else
            Array.new
          end
        end
      else
	a = { "CONTENT_TYPE" => get_getresponse.headers['content-type'],
	      "CONTENT_LENGTH" => (response.size).to_s,
	      :input => response }

	env = Rack::MockRequest.env_for("/", a)
	params = Rack::Utils::Multipart.parse_multipart(env)

	x = { "CONTENT_TYPE" => params['attachments'][:type],
	      "CONTENT_LENGTH" => (params['attachments'][:tempfile].size).to_s,
	      :input =>  params['attachments'][:tempfile]}

	env2 = Rack::MockRequest.env_for("/", x)
	params2 = Rack::Utils::Multipart.parse_multipart(env2)

	response2 = { "root-fields" => params['root-fields'],
	              "attachments" => params2 }
      end
    end

    # 
    # Send a startMMSNotification request to the endpoint
    # [*destination*] destination number
    # [*endpoint*] endpoint (basically an owned HTTP server) to deliver SMS notification
    # [*correlator*] unique identifier (optional)
    # [*criteria*] Text to match in order to determine the application that shall receive the notification.
    # This text is matched against the first word in the message (optional).
    # returns the location where the notification can be checked
    # 
    def start_mms_notification(destination, endpoint, correlator, criteria = nil, get_url = false)
      @notif = MessageNotificationType.new(
        SimpleReferenceType.new(endpoint, correlator),
        [UserIdType.new(destination, nil,nil,nil, nil)],
        criteria)

      message = Utils.object_to_json(@notif)
  

      response = POST("#{get_basepath}/inbound/subscriptions", message.to_s)
      unless response.nil?
        if response.headers.has_key? 'location'
          location = response.headers['location']
          unless get_url
            location.gsub(/^.+\/subscriptions\/([^\/]+)/, '\1')
          else
            location.to_s
          end
        else
          raise RuntimeError, "Error #{response.code}. Unable to start MMS notification: #{response.body}"
        end
      else
        raise RuntimeError, "Unable to connect with endpoint."
      end
    end

    #
    # This method stop the message notification (MO)
    # [*subscription_id*] The subscription identifier to be deleted
    #
    def get_delivery_receipt_notification_type(endpoint, correlator, origin)

      origin_alias, origin_number = get_origin(origin)

      user_id_type = UserIdType.new(origin_number, nil, nil, origin_alias, nil)

      @deliv = Schemas::Mms_types::DeliveryReceiptNotificationType.new(
        Schemas::Mms_types::SimpleReferenceType.new(endpoint,correlator),
        [user_id_type])
    end

    
    #
    # This method stop the message notification (MO)
    # [*subscription_id*] The subscription identifier to be deleted
    #
    def stop_mms_notification(subscription_id)
      stop_message_notification(subscription_id)
    end
  end
end
