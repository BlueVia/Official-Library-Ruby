#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module Schemas
    #
    # RequestToken object for OAuth Client 
    # attributes:
    # [*token*] From OAuth::Token obj 
    # [*secret*] From OAuth::Token obj 
    # [*auth_url*] Url to authorize application  
    #
    class RequestToken  < OAuth::Token
      
      attr_accessor :auth_url
      
      def initialize (request_token = nil, auth_url = nil)
        unless request_token.nil?
          @token = request_token.token
          @secret = request_token.secret
          @auth_url = auth_url
        else
          @token = @secret = @auth_url = nil
        end
          
      end
    end
  end
end