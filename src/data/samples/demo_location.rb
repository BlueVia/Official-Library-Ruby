#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bluevia'
 
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class DemoLocation 
  include Bluevia
  
  begin
    
    consumer_key= "vw12012654505986"
    consumer_secret= "WpOl66570544"
    mode= BVMode::SANDBOX
    token= "ad3f0f598ffbc660fbad9035122eae74"
    token_secret= "4340b28da39ec36acb4a205d3955a853"
    
    # To create Bluevia client
    @bc = BVLocation.new(mode, consumer_key, consumer_secret, token, token_secret)
        
    # Request for location information 
    response = @bc.get_location()
    
    puts response.coordinates_latitude
    puts response.coordinates_longitude
    puts response.report_status
           
  rescue StandardError => e
    puts "received Exception: #{e}" # do whatever
  end
    
end
