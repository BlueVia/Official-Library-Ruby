#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bluevia'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class DemoAdvertising
  include Bluevia
  
  begin
    
    consumer_key= "vw12012654505986"
    consumer_secret= "WpOl66570544"
    mode= BVMode::SANDBOX
    token= "ad3f0f598ffbc660fbad9035122eae74"
    token_secret= "4340b28da39ec36acb4a205d3955a853"
    
    # To create Bluevia BVAdvertising client
    @bc = BVAdvertising.new(mode, consumer_key, consumer_secret, token, token_secret)
  
    # A set of params
    user_agent = "Mozilla 5.0"
    ad_request_id = "10654CC10-11-05T20:31:13c6c72731ad"
    ad_space = "BV15125"
    country = "MX" #ISO 3166
    
    # Request for advertising information 
    response = @bc.get_advertising_3l(ad_space, country, ad_request_id, ad_presentation = nil, keywords = nil, protection_policy = nil, user_agent)
    
    puts response.inspect
    
  rescue StandardError => e
    puts "received Exception: #{e}"
  end
  
end
