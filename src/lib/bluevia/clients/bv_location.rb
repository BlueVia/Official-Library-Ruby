#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/clients/bv_location_client'

module Bluevia

  #
  # Bluevia Location API is a set of functions which allows users to retrieve the
  # geographical coordinates of a terminal where Location is expressed through a
  # latitude, longitude, altitude and accuracy. Such operation covers the requesting
  # for the location of a terminal.
  #
  # This class fetches information related to Location API.
  #

  class BVLocation < BVLocationClient

    #
    # To create BVLocation clients to get customer's location info from the gSDP (3 legged clients)
    #
    # required params :
    # [*mode*]            Communication mechanism to communicate with the gSDP
    #                     BVMode::LIVE (also SANDBOX and TEST available)
    # [*consumer_key*]    Oauth consumer key supplied by the developer.
    # [*consumer_secret*] Oauth consumer secret supplied by the developer.
    # [*token_key*]       Oauth access token key returned by the get_access_token call.
    # [*token_secret*]    Oauth access token secret returned by the get_access_token call.
    #
    # example:
    #   @bc = BVLocation.new(Bluevia::BVMode::LIVE,"XXXXX", "YYYYY", "WWWWWWWWWWWWWW", "ZZZZZZZZZZZZZ") 
    #

    def initialize(mode, consumer_key, consumer_secret, token_key, token_secret)

      init_untrusted(mode, consumer_key, consumer_secret, token_key, token_secret)
        
      if mode.eql? SANDBOX
        is_sandbox("/" + BP_LOC)
      else 
        @base_uri = @base_uri + "/" + BP_LOC
      end
      
    end
    
    #
    # Retrieves location of the terminal
    #
    # optional params :
    # [*acc_accuracy*] Accuracy, in meters, that is acceptable for a response
    #
    # returns a Bluevia::Schemas::LocationInfo object that contains location data
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_location
    #

    def get_location(acc_accuracy = nil)
      super(nil, acc_accuracy)
    end
  end
end
