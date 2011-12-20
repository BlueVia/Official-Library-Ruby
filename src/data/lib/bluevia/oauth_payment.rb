#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'oauth/client'

module OAuth::Client
 #
 # Code inyection in OAuth::Client::Helper class, oauth_parameters
 # Normal OAuth method does not include the required xoauth_apiName option
 # in the OAuth header parameters hash
 # 
  class Helper
    def oauth_parameters
      {
        'oauth_body_hash'        => options[:body_hash],
        'oauth_callback'         => options[:oauth_callback],
        'oauth_consumer_key'     => options[:consumer].key,
        'oauth_token'            => options[:token] ? options[:token].token : '',
        'oauth_signature_method' => options[:signature_method],
        'oauth_timestamp'        => timestamp,
        'oauth_nonce'            => nonce,
        'oauth_verifier'         => options[:oauth_verifier],
        'oauth_version'          => (options[:oauth_version] || '1.0'),
        'oauth_session_handle'   => options[:oauth_session_handle],
        'xoauth_apiName'         => options[:xoauth_apiName]
      }.reject { |k,v| v.to_s == "" }
    end
  end
end

module Bluevia
  #
  # This class can be used to launch oAuth authentication mechanism for payment ops.
  # User authentication is launched using oAuth protocol, so user is not required to use credentials
  # in third party applications. 
  #
  
  class OauthPayment < Oauth
           
    #
    # Gets request token, secret and uri for user validation
    # [*_params*] hash object :
    #      required params :
    #          :paymentInfo => <PaymentInfoType> (amount and currency are compulsory params)
    #          :name => SERVICEINFO_NAME (provided by service provider)
    #          :serviceID => SERVICEINFO_SERVICEID (provided by service provider)
    #      optional params:
    #          :callback => "oob" (or actual callback url) 
    #
    def get_request_token(_params )
      
      consumer=OAuth::Consumer.new \
        @consumer_key,
        @consumer_secret,
        {
          :site               => @@base_uri,
          :signature_method   => "HMAC-SHA1",
          :request_token_path => "#{BASEPATH}/Oauth/getRequestToken",
          :access_token_path  => "#{BASEPATH}/Oauth/getAccessToken",
          #:proxy              => "http://localhost:8888",
          :http_method        => :post
        }

      params = Hash.new      
      params[:xoauth_apiName] = "Payment" + (@commercial ? "" : "_Sandbox")

      if _params.has_key?(:callback)
        callback=_params[:callback]
        if callback.nil?
          params[:oauth_callback]="oob"
        else
          params[:oauth_callback] = _params[:callback]
        end
      else
         params[:oauth_callback]="oob"
      end
      
      if _params.has_key?(:uri)
        uri = _params[:uri]
      else
        uri = AUTHORIZE_URI
      end	
      
      if _params.has_key?(:serviceID)
        service_id = _params[:serviceID]
      else
        raise ClientError, "serviceID parameter must be provided"
      end
      
      if _params.has_key?(:name)
        service_name = _params[:name]
      else
        raise ClientError, "name parameter must be provided"
      end
      
      if _params.has_key?(:paymentInfo)
        unless _params[:paymentInfo].amount.nil?
          amount = _params[:paymentInfo].amount
        else
          raise ClientError, "amount parameter must be provided"
        end
        unless _params[:paymentInfo].currency.nil?
          currency = _params[:paymentInfo].currency
        else
          raise ClientError, "currency parameter must be provided"
        end
      else
          raise SyntaxError, "paymentInfo hash must be provided"
      end  
     
      if  params[:oauth_callback].instance_of?(String)
        unless params[:oauth_callback][0..3].eql?("http") or params[:oauth_callback].eql?("oob")
            raise SyntaxError, "Wrong callback parameter"
        end
      else 
        raise SyntaxError, "Callback parameter must be a String"
      end
    
      body = Hash.new
      body["serviceInfo.name"] = service_name
      body["serviceInfo.serviceID"] = service_id
      body["paymentInfo.amount"] = amount
      body["paymentInfo.currency"] = currency
      request_token = consumer.get_request_token(params, body)
       
      return request_token.token, request_token.secret, "#{uri}?oauth_token=#{request_token.token}"
       
  
    end # get_request_token
  end # OauthPayment
end # Bluevia