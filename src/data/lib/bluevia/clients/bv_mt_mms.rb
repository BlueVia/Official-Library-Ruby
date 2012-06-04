#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


require 'rack'
require 'bluevia/clients/bv_mt_mms_client'


module Bluevia
  
  #
  # Bluevia MMS API is a set of functions which allows users to send MMS messages
  # and to request the status of those previously sent MMS messages.
  #
  # This class fetches information related to MMS Mobile Terminated API.
  # 

  
  class BVMtMms < BVMtMmsClient
    
    #
    # To create BVMtMms clients to access bluevia Mms Mt functionality (3 legged clients)
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
    #   @bc = BVMtMms.new(Bluevia::BVMode::LIVE,"XXXXX", "YYYYY", "WWWWWWWWWWWWWW", "ZZZZZZZZZZZZZ") 
    #

    def initialize(mode, consumer_key, consumer_secret, token_key, token_secret)
     
      init_untrusted(mode, consumer_key, consumer_secret, token_key, token_secret)

      if mode.eql? SANDBOX
        is_sandbox("/" + BP_MMS)
      else 
        @base_uri = @base_uri + "/" + BP_MMS
      end 
    end 

    #
    # Allows to send and MMS to the gSDP.
    # 
    # required params :
    # [*destination*] Array, fixnum or string with the destination numbers
    # [*subject*]     Subject for the multimedia message
    # optional params :
    # [*message*]     Text message of the MMS
    # [*attachment*]  Multimedia file to send. Bluevia::Schemas::Attachment class is 
    #                 provided to help customer to send attachments.
    #                 mime types allowed: 
    #                   text/plain image/jpeg image/bmp image/gif image/png audio/amr audio/midi  
    #                   audio/mp3 audio/mpeg audio/wav video/mp4 video/avi video/3gpp
    # [*endpoint*]    Endpoint to receive notifications of sent MMSs
    # [*correlator*]  Correlator to receive notifications of sent MMSs
    #
    # returns a String containing the id of the MMS sent.
    # raise BlueviaError
    #
    # example:
    #   attach << Bluevia::Schemas::Attachment.new("/home/user23/attach_file.mp3", "audio/mp3")
    #   response = @bc.send("3423456", "MMS subject", "Text message here", attach)
    #
    
    def send(destination, subject, message = nil, attachment = nil, endpoint = nil, correlator = nil)
      super(destination, subject, nil, message, attachment, nil, nil, endpoint, correlator)
    end
  
  end
end
