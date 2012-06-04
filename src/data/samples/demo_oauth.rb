#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bluevia'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#
# (c) Bluevia (mailto:support@bluevia.com)
#

class DemoOauth 
  include Bluevia
  
  begin
    consumer_key= "xxxxxx"
    consumer_secret= "yyyyyyy"
    mode= BVMode::SANDBOX

    # To create  client
    @bc = BVOauth.new(mode, consumer_key, consumer_secret)
    
    # In order to authorize application
    request_token = @bc.get_request_token

    puts "To get access token and secret, we need you to finish the authorization process following this url: "+request_token.auth_url
    puts "Please, introduce the obtained pin code:"
  
    STDOUT.flush  
    pin_code= gets.chomp  
  
    # To get access tokens
    access_token = @bc.get_access_token(pin_code, request_token.token, request_token.secret)
  
    puts "Your access token and secret for the selected application are " +access_token.token+ " and "+access_token.secret
  rescue BlueviaError => e
    puts "received Exception: #{e}" #do whatever
  end
  
  
end
