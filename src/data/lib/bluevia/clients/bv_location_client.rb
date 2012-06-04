#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/schemas/sch_location'
require 'bluevia/clients/commons/bv_base_client'


module Bluevia

  class BVLocationClient < BVBaseClient
      
  private
  
    #
    # This method complete common features for trusted and untrusted location API
    #
    # optional params :
    # [*phone_number*] Phone number of Telefonica customer
    # [*acc_accuracy*] Accuracy, in meters, that is acceptable for a response
    #
    # returns a Bluevia::Schemas::LocationInfo object that contains location data
    #
  
    def get_location(phone_number = nil, acc_accuracy = nil)
      
      params = Hash.new
      
      unless acc_accuracy.nil?
        params[:acceptableAccuracy] = acc_accuracy
      end
      unless phone_number.nil?
        params[:locatedParty] = "phoneNumber:#{phone_number}"
      else
        params[:locatedParty] = "alias:#{@Ic.get_token}"
      end
      
      response = base_retrieve("/TerminalLocation", params)
      return filter_response(response)
    end
  
    #
    # Filters response to fill LocationInfo and
    # returns BlueviaError if LocationInfo wasn't successfully created
    #
  
    def filter_response(response)
      
      return LocationInfo.new if response.nil? or !response.instance_of?(Hash)

      result = LocationInfo.new
      
      begin
        result.report_status = response['terminalLocation']['reportStatus']
        result.coordinates_latitude = response['terminalLocation']['currentLocation']['coordinates']['latitude']
        result.coordinates_longitude = response['terminalLocation']['currentLocation']['coordinates']['longitude']
        result.accuracy = response['terminalLocation']['currentLocation']['accuracy']
        result.timestamp = response['terminalLocation']['currentLocation']['timestamp']
        
        return result
        
      rescue StandardError => error
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "create LocationInfo."
        raise BlueviaError.new(e)
      end
    end
    
    def init_untrusted(mode, consumerKey, consumerSecret, tokenKey, tokenSecret)
      
      super
      init
      
    end
    def init_trusted(mode, consumerKey, consumerSecret, cert_file, cert_pass)
      
      super
      init

    end
    
    #
    # This method sets parser and serializer for Location client
    # It also complete Rest part of the URL
    #

    def init
      @Is = Bluevia::ISerializer::JsonSerializer.new
      @Ip = Bluevia::IParser::JsonParser.new
      is_rest

    end
  end
end

