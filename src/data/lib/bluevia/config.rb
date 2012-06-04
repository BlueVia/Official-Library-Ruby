#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

module Bluevia
 
  AUTH_URI_LIVE = "https://connect.bluevia.com/authorise/"
  AUTH_URI_TEST = "https://bluevia.com/test-apps/authorise/"
  AUTH_URI_SANDBOX = "https://bluevia.com/test-apps/authorise/"
      
  RPC_URL = "/services/RPC"
  REST_URL = "/services/REST" 
 
  OAUTH_ACCESS = "/Oauth/getAccessToken"
  OAUTH_REQUEST = "/Oauth/getRequestToken"
  SIGNATURE = "HMAC-SHA1"
 
  LIVE = "LIVE"
  SANDBOX = "SANDBOX"
  TEST = "TEST"
 
  BASEPATH_SANDBOX    = "_Sandbox"
 
  BP_OAUTH = "Oauth"
  BP_SMS = "SMS"
  BP_MMS = "MMS"
  BP_ADV = "Advertising"
  BP_PAY = "Payment"
  BP_LOC = "Location"
  BP_DIR = "Directory"
 
  MS_OUT = "/outbound/requests"
  MS_IN = "/inbound"
  MS_SUBS = "/subscriptions"
 
  DEFAULT_PARAMS = {:version => "v1", :alt => "json"}
  
  COD_1 = '-1'
  COD_2 = '-2'
  COD_3 = '-3'
  COD_5 = '-5'
  COD_6 = '-6'
  COD_7 = '-7'
  COD_8 = '-8'
  COD_9 = '-9'
  COD_10 = '-10'
  COD_11 = '-11'
  COD_12 = '-12' 
  COD_13 = '-13' 
  
  ERR_PART1 ="Bad request: The parameter"
  ERR_PART2 ="cannot be nil."
  ERR_PART3 = "Unable to "
  ERR_PART4 = "must be a number."
  ERR_PART5 = "must be a string."
  ERR_ADV = "Function only available in"
  
  ERR_TK = ERR_PART1 + " 'tokenKey' or 'tokenSecret' " + ERR_PART2
  ERR_MD = ERR_PART1 + " 'mode' " + ERR_PART2
  
  ERR_MS1 = "Both, endpoint and correlator must be provided."
 
  ERR_CON = "Unable to connect with endpoint."
  ERR_NI = " Not implemented: Method not implemented in current version."
  ERR_OAU =  "Wrong oauth arguments."
 
  ERR_MOD = ERR_PART1 + " 'mode' must be (\"LIVE\", \"TEST\" or \"SANDBOX\")."
  ERR_ADV2 = "An ISO-3166 country is required in two legged authorization."
  ERR_INV = "Invalid mode."
  ERR_OAU2 = "SMSHandshake is just available for LIVE mode."
  
  ERR_PARS = "Error parsing."
  ERR_SER = "Error serializing."
 
  ERR_MS5 = "Unable to create message." 
 
  BVEXCEPTS = {
    ERR_MOD => COD_1, ERR_TK => COD_1, ERR_MD => COD_1, ERR_OAU => COD_1,
    ERR_CON => COD_2, 
    ERR_NI => COD_3,
    ERR_OAU2 => COD_7, ERR_ADV => COD_7, ERR_INV => COD_7,
    ERR_ADV2 => COD_9,
    ERR_PARS => COD_10,
    ERR_SER => COD_11,
    ERR_MS5 => COD_12
  }
  
  DS_DTN = "DeliveredToNetwork"
  DS_DU = "DeliveryUncertain"
  DS_DI = "DeliveryImpossible"
  DS_MW = "MessageWaiting"
  DS_DTT = "DeliveredToTerminal"
  DS_DNNS = "DeliveryNotificationNotSupported"
  
  DS_DTN_INFO = "The message has been delivered to the network. Another state could be available later to inform if the message was finally delivered to the handset."
  DS_DU_INFO = "Delivery status unknown."
  DS_DI_INFO = "Unsuccessful delivery. The message could not be delivered before it expired."
  DS_MW_INFO = "The message is still queued for delivery. This is a temporary state, pending transition to another state."
  DS_DTT_INFO = "The message has been successful delivered to the handset."
  DS_DNNS_INFO = "Unable to provide delivery status information because it is not supported by the network."
  
  BVDELIVERYSTATUS= {
    DS_DTN => DS_DTN_INFO, DS_DU => DS_DU_INFO, DS_DI => DS_DI_INFO,
    DS_MW => DS_MW_INFO, DS_DTT => DS_DTT_INFO, DS_DNNS => DS_DNNS_INFO 
  }
  
  BVDELIVERYSTATUSMESSAGES= [DS_DTN, DS_DU, DS_DI, DS_MW, DS_DTT, DS_DNNS] 
  class BVMode
    
    LIVE = LIVE
    SANDBOX = SANDBOX
    TEST = TEST
    
  end  
end