#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


require 'bluevia/clients/bv_mt_sms_client'

module Bluevia
  
  #
  # Bluevia SMS API is a set of functions which allows users to send SMS messages
  # and to request the status of those previously sent SMS messages.
  #
  # This class fetches information related to SMS Mobile Terminated API.
  #
  class BVMtSms < BVMtSmsClient
    
    #
    # To create BVMtSms clients to access bluevia Sms Mt functionality (3 legged clients)
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
    #   @bc = BVMtSms.new(Bluevia::BVMode::LIVE,"XXXXX", "YYYYY", "WWWWWWWWWWWWWW", "ZZZZZZZZZZZZZ") 
    #
  
    def initialize(mode, consumer_key, consumer_secret, token_key, token_secret)
      
      init_untrusted(mode, consumer_key, consumer_secret, token_key, token_secret)

      if mode.eql? SANDBOX
        is_sandbox("/" + BP_SMS)
      else 
        @base_uri = @base_uri + "/" + BP_SMS
      end 

    end
    
    #
    # Allows to send and SMS to the gSDP.
    # 
    # required params :
    # [*destination*] Array, fixnum or string with the destination numbers
    # [*text*]        Text message of the SMS
    # optional params :
    # [*endpoint*]    Endpoint to receive notifications of sent MMSs
    # [*correlator*]  Correlator to receive notifications of sent MMSs
    #
    # returns a String containing the id of the SMS sent.
    # raise BlueviaError
    #
    # example:
    #   response = @bc.send("3423456", "Text message here")
    #

    def send(destination, text, endpoint = nil, correlator = nil)
      super(destination, text, nil, nil, nil, endpoint, correlator)
    end

  end
end
