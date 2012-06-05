#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/clients/bv_advertising_client'

module Bluevia

  #
  # Bluevia Advertising API is a set of functions which allows users to provide 
  # advertising based on different advertisement type such as images or texts or 
  # similar elements within their applications. This guide represents a practical 
  # introduction to developing applications in which the user wants to provide the 
  # Bluevia Advertising functionality.
  #
  # This class fetches information related to Advertising API.
  #

  class BVAdvertising < BVAdvertisingClient
    
    #
    # To create BVAdvertising clients to get Ads from the gSDP (both 2 or 3 legged clients)
    # required params :
    # [*mode*]            Communication mechanism to communicate with the gSDP
    #                     BVMode::LIVE (also SANDBOX and TEST available)
    # [*consumer_key*]    Oauth consumer key supplied by the developer.
    # [*consumer_secret*] Oauth consumer secret supplied by the developer.
    # optional params (mandatory if three legged oauth):
    # [*token_key*]       Oauth access token key returned by the get_access_token call.
    # [*token_secret*]    Oauth access token secret returned by the get_access_token call.
    #
    # example:
    #   @bc = BVAdvertising.new(Bluevia::BVMode::LIVE,"XXXXX", "YYYYY") -> two legged ouath
    #   @bc = BVAdvertising.new(Bluevia::BVMode::LIVE,"XXXXX", "YYYYY", "WWWWWWWWWWWWWW", "ZZZZZZZZZZZZZ") -> three legged oauth
    #
    
    def initialize(mode, consumer_key, consumer_secret, token_key=nil, token_secret=nil)
        
      init_untrusted(mode, consumer_key, consumer_secret, token_key, token_secret)
      
      if mode.eql? SANDBOX
        is_sandbox("/" + BP_ADV)
      else 
        @base_uri = @base_uri + "/" + BP_ADV
      end
      
    end
    
    #
    # This method fetchs an Ad from the server with 3 legged client
    #
    # required params :
    # [*ad_space*]          Adspace of Bluevia application
    # optional params :
    # [*country*]           Country where the target user is located. 
    #                       Must follow ISO-3166 (see http://www.iso.org/iso/country_codes.htm).
    # [*ad_request_id*]     An unique id for the request. 
    #                       If it is not set, the SDK will generate it automatically
    # [*ad_presentation*]   Value is a code that represents ad's format type
    #                       Bluevia::Schemas::TypeId::IMAGE (TEXT also available)
    # [*keywords*]          Array with keywords the ads are related to, separated by comas
    # [*protection_policy*] Adult control policy. It will be safe, low, high. 
    #                       It should be checked with the application SLA in the gSDP.
    #                       Bluevia::Schemas::ProtectionPolicy::LOW (HIGH and SAFE also allowed)
    # [*user_agent*]        User agent of the client
    #
    # returns a Bluevia::Schemas::SimpleAdResponse object that contains the ad meta-data
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_advertising_3l(ad_space = "BVxxxx", 
    #                                     country = nil, ad_request_id = nil, 
    #                                     ad_presentation = Bluevia::Schemas::TypeId::IMAGE, 
    #                                     keywords = ["computer", "laptop"], 
    #                                     protection_policy = Bluevia::Schemas::ProtectionPolicy::LOW, 
    #                                     user_agent = "Mozilla 5.0")
    #
    
    def get_advertising_3l(ad_space, country = nil, ad_request_id = nil, ad_presentation = nil, keywords = nil, protection_policy = nil, user_agent = nil)
      
      if @Ic.get_token.nil?
        e = BVResponse.new
        e.code = BVEXCEPTS[ERR_ADV]
        e.message = ERR_ADV + " three legged authentication."
      end
      # Calls auxiliary method to complete common parts for both advertising methods
      params = get_adv(ad_space, country, ad_request_id, ad_presentation, keywords, protection_policy, user_agent, nil)
      
      begin
        resp = base_create("/simple/requests", nil, params, nil)
        return filter_response(resp)
        
      rescue BlueviaError => ie 
        if ie.code.eql?"-10"
          error_parsed = @err_parser.parse(@Ir.additional_data[:body])
          @Ir.message = parse_error(error_parsed)
        
          raise BlueviaError.new(@Ir)
        else
          raise BlueviaError.new(ie)
        end
      end
           
      filter_response(resp)      
    end
    
    #
    # This method fetchs an Ad from the server with 2 legged client
    #
    # required params :
    # [*ad_space*]          Adspace of the Bluevia application
    # [*country*]           Country where the target user is located. 
    #                       Must follow ISO-3166 (see http://www.iso.org/iso/country_codes.htm).
    # optional params :
    # [*target_user_id*]    Identifier of the Target User
    # [*ad_request_id*]     An unique id for the request. 
    #                       If it is not set, the SDK will generate it automatically
    # [*ad_presentation*]   Value is a code that represents ad's format type
    #                       Bluevia::Schemas::TypeId::IMAGE (TEXT also available)
    # [*keywords*]          Array with keywords the ads are related to, separated by comas
    # [*protection_policy*] Adult control policy. It will be safe, low, high. 
    #                       It should be checked with the application SLA in the gSDP.
    #                       Bluevia::Schemas::ProtectionPolicy::LOW (HIGH and SAFE also allowed)
    # [*user_agent*]        User agent of the client
    #
    # returns a Bluevia::Schemas::SimpleAdResponse object that contains the ad meta-data
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_advertising_2l(ad_space = "BVxxxx", 
    #                                     country = "DE", 
    #                                     targe_user_id = nil, ad_request_id = nil, 
    #                                     ad_presentation = Bluevia::Schemas::TypeId::IMAGE, 
    #                                     keywords = ["computer", "laptop"], 
    #                                     protection_policy = Bluevia::Schemas::ProtectionPolicy::LOW, 
    #                                     user_agent = "Mozilla 5.0")
    #
    
    def get_advertising_2l(ad_space, country, target_user_id = nil, ad_request_id = nil, ad_presentation = nil, keywords = nil, protection_policy = nil, user_agent = nil)
      
      if @Ic.get_token.nil?
        Utils.check_attribute(
          country, ERR_ADV2)
          
      else
        e = BVResponse.new
        e.code = BVEXCEPTS[ERR_ADV]
        e.message = ERR_ADV + " two legged authentication."
      end
      # Calls auxiliary method to complete common parts for both advertising methods
      super(ad_space, country, nil, target_user_id, ad_request_id, ad_presentation, keywords, protection_policy, user_agent)
    end
  end
end
