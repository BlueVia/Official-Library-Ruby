#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


require 'bluevia/clients/commons/bv_base_client'
require 'bluevia/schemas/sch_oauth'

module Bluevia


  class BVOauthClient < BVBaseClient
    
    #
    # Retrieves a request token
    # 
    # optional params :
    # [*callback*]  Endpoint to receive verification url
    #
    # returns an Bluevia::Schemas::RequestToken
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_request_token
    #

    def get_request_token(callback = "oob")
      e = BVResponse.new
      e.code = COD_1
      
      params = Hash.new
      if callback.eql?"" or callback.nil?
        callback = "oob"
      end
      if callback.instance_of?(String) 
        if callback.to_i==0 
          params[:oauth_callback] = callback
        else
          e.message = ERR_PART1 + " 'callback' " + ERR_PART5
          raise BlueviaError.new(e)
        end
        
      else
        e.message = ERR_OAU
        raise BlueviaError.new(e)
      end

      begin
        req_toks = @Ic.get_request_token(params)
        @request_pair = OAuth::Token.new(req_toks.token, req_toks.secret)
        
        resp = RequestToken.new(@request_pair, "#{@auth_uri}?oauth_token=#{@request_pair.token}")

        return resp

      rescue ConnectionError => oauth_error
        e= BVResponse.new
        e.code = oauth_error.code
        
        begin
          error_parsed = @Ip.parse oauth_error.additional_data[:body]
          e.message = parse_error(error_parsed)
        rescue
          e.message = oauth_error.message
          e.additional_data = oauth_error.additional_data
          raise ConnectionError.new(e)
        end
        raise BlueviaError.new(e)
          
      end
        
    end
    
    #
    # Retrieves a request token using the Bluevia SMS handshake
    # Oauth verifier will be received vía SMS in the phone number specified as a parameter,
    # instead of getting a verification url.
    # Note that this feature is only available for LIVE mode.
    # 
    # required params :
    # [*phone_number*]  phoneNumber the phone number to receive the SMS with the oauth verifier (PIN code)
    #
    # returns an OAuth::Token
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_request_token_smsHandshake("3412345678")
    #
    
    def get_request_token_smsHandshake(phone_number)
      
      Utils.check_attribute(phone_number, ERR_PART1 + " 'phone_number' " + ERR_PART2)
      Utils.check_number(phone_number, ERR_PART1 +  "'phone_number' " + ERR_PART4)
      
      params = Hash.new
      
      if phone_number.to_i!=0 # phone_number is a number
        
        if !@mode.eql? LIVE # only for LIVE mode
          e = BVResponse.new
          e.code = BVEXCEPTS[ERR_OAU2]
          e.message = ERR_OAU2
          raise BlueviaError.new(e)
        else
          params[:oauth_callback]=phone_number
        end
      else
        e = BVResponse.new
        e.code = BVEXCEPTS[ERR_OAU]
        e.message = ERR_OAU
        raise BlueviaError.new(e)
      end
      begin
        req_toks = @Ic.get_request_token(params)
        @request_pair = OAuth::Token.new(req_toks.token, req_toks.secret)
    
        return @request_pair
      rescue ConnectionError => oauth_error
        e= BVResponse.new
        e.code = oauth_error.code
        
        begin
          error_parsed = @Ip.parse oauth_error.additional_data[:body]
          e.message = parse_error(error_parsed)
        rescue
          e.message = oauth_error.message
          e.additional_data = oauth_error.additional_data
          raise ConnectionError.new(e)
        end
        raise BlueviaError.new(e)
          
      end
    end
  
    #
    # Retrieves the access token corresponding to request token parameter
    # 
    # required params :
    # [*oauth_verifier*]  OAuth verifier for the token (pin code)
    # optional params :
    # [*request_token*]   If not provided SDK will use last request token received
    # [*request_secret*]  If not provided SDK will use last request secret received
    #
    # returns an access token in an OAuth::Token object
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_access_token("1234")
    #
    
    def get_access_token(oauth_verifier, request_token=nil, request_secret=nil)
      if request_token.nil? and request_secret.nil?
        
        request_token = @request_pair.token
        request_secret = @request_pair.secret
      end

      begin
        
        access_resp = @Ic.get_access_token(request_token, request_secret, oauth_verifier)
        @access_pair = OAuth::Token.new(access_resp.token, access_resp.secret)

        return @access_pair
      rescue ConnectionError => oauth_error
        e= BVResponse.new
        e.code = oauth_error.code
        
        begin
          error_parsed = @Ip.parse oauth_error.additional_data[:body]
          e.message = parse_error(error_parsed)
        rescue
          e.message = oauth_error.message
          e.additional_data = oauth_error.additional_data
          raise ConnectionError.new(e)
        end
        raise BlueviaError.new(e)
          
      end
    
    end
    
    private
    
    #
    # This method sets parser and serializer for Oauth client (note that no serializer is needed)
    #
    def init_untrusted(mode, consumer_key, consumer_secret,  token_key=nil, token_secret=nil)
      
      super
      @Is = nil
      @Ip = Bluevia::IParser::XmlParser.new
    end
   
  end
end