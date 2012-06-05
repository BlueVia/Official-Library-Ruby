#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/clients/bv_oauth_client'

module Bluevia
  
  #
  # Bluevia OAuth API is a set of functions which allows applications to retrieve
  # request and access tokens to complete the OAuth authentication protocol,
  # necessary to be able to get and send data to Bluevia APIs.
  # 

  class BVOauth < BVOauthClient
    
    #
    # This class can be used to launch oAuth authentication mechanism when
    # a user is using the application for the first time. It provides access 
    # to the set of functions to complete the OAuth workflow to
    # retrieve the OAuth credentials for Bluevia applications.
    #
    # required params :
    # [*mode*]            Communication mechanism to communicate with the gSDP
    #                     BVMode::LIVE (also SANDBOX and TEST available)
    # [*consumer_key*]    Oauth consumer key supplied by the developer.
    # [*consumer_secret*] Oauth consumer secret supplied by the developer.
    #
    # example:
    #   @bc = BVOauth.new(Bluevia::BVMode::LIVE, "XXXXX", "YYYYY") 
    #

    def initialize(mode, consumer_key, consumer_secret)
      
      init_untrusted(mode, consumer_key, consumer_secret, nil, nil)
      
      is_rest    
      
      if mode.eql? SANDBOX
        is_sandbox("/" + BP_OAUTH)
      else 
        @base_uri = @base_uri + "/" + BP_OAUTH
      end
      

    end
  end
end
