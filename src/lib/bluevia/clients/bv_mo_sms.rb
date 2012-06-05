#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


require 'bluevia/clients/bv_mo_sms_client'

module Bluevia
  
  #
  # The Bluevia SMS Mobile Originated API is a set of functions which 
  # allows users to receive SMS messages sent from a mobile phone. 
  #
  # This class fetches information related to SMS Mobile Originated API.
  # 
  
  class BVMoSms < BVMoSmsClient
    
    #
    # To create BVMoSms clients to access bluevia Sms Mo functionality (2 legged clients)
    #
    # required params :
    # [*mode*]            Communication mechanism to communicate with the gSDP
    #                     BVMode::LIVE (also SANDBOX and TEST available)
    # [*consumer_key*]    Oauth consumer key supplied by the developer.
    # [*consumer_secret*] Oauth consumer secret supplied by the developer.
    #
    # example:
    #   @bc = BVMoSms.new(Bluevia::BVMode::LIVE, "XXXXX", "YYYYY") 
    #

    def initialize(mode, consumer_key, consumer_secret)
      

      init_untrusted(mode, consumer_key, consumer_secret, nil, nil)
      
      if mode.eql? SANDBOX
        is_sandbox("/" + BP_SMS)
      else 
        @base_uri = @base_uri + "/" + BP_SMS
      end 
      

    end
  end
end
