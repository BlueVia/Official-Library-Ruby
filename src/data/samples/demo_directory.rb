#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bluevia'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#
# (c) Bluevia (mailto:support@bluevia.com)
#

class DemoDirectory

  include Bluevia
  include Bluevia::Schemas
  
  begin
    
    consumer_key= "vw12012654505986"
    consumer_secret= "WpOl66570544"
    mode= BVMode::SANDBOX
    token= "ad3f0f598ffbc660fbad9035122eae74"
    token_secret= "4340b28da39ec36acb4a205d3955a853"
    
    # To create Bluevia BVDirectory client
    @bc = BVDirectory.new(mode, consumer_key, consumer_secret, token, token_secret)
    
    # To get all user info
    
    #all_info = @bc.get_user_info
    #puts all_info.inspect
    
    # To filter only user access info and user terminal info
    #filtered_dataset = @bc.get_user_info([DirectoryDataSets::USER_ACCESS_INFO, DirectoryDataSets::USER_PROFILE])
    #puts filtered_dataset.inspect
    
    # To get only roaming information inside access info block
    filtered_field = @bc.get_access_info([AccessFields::ROAMING])
    puts filtered_field.roaming
        
  rescue StandardError => e
    puts "received Exception: #{e}"
  end

end
