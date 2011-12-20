#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'oauth'
require 'oauth/signature/hmac/sha1'
require 'oauth/client/helper'

module Bluevia
  #
  # This class can be used to launch oAuth authentication mechanism when
  # a user is using the application for the first time
  #
  # User authentication is launched using oAuth protocol, so user is not required to use credentials in third party applications. 
  # When user wants to launch the oAuth process, once the Bluevia client has been created only the two lines below are required to retrieve a valid token for user:
  #
  #  @service = @bc.get_service(:oAuth)
  #  token, secret, url = @service.get_request_token({:callback =>"http://foo.bar"})
  #
  #  Note that :callback is an optional parameter. 
  #  If it's defined you will receive the oauth_verifier as a request parameter at your callback_url. 
  #  If it's not defined you will have to ask the user to enter the PIN code (oauth_verifier) in your application.
  #  Finally if :callback parameter is provided, it can also be a string with an MSISDN as follows:
  #
  #  token, secret, url = @service.get_request_token("34567890")
  #
  #  The retrieved parameter token and secret should be use during the oAuth process, and url is the endpoint where Bluevia shall authenticate the user. In case of a Rails application, the lines below could be used:
  #
  #  token, token_secret, url = @service.get_request_token("http://juan.pollinimini.net/bluevia/get_access")
  #  cookies[:token] = "#{token}|#{token_secret}"
  #  redirect_to(url)
  #
  # Once user is authenticated and she authorized the application in BlueVia portal, she should be redirected to the URL used as parameter before. Now it's time to fetch the valid token and token secret that shall identify the new user during any call to BlueVia API. Lines below show an example using Rails:
  #
  #  def get_access
  #     oauth_verifier = params[:oauth_verifier]
  #     get_token_from_cookie
  #     @bc = BlueviaClient.new(
  #       { :consumer_key   => CONSUMER_KEY,
  #         :consumer_secret=> CONSUMER_SECRET
  #       })
  #     @service = @bc.get_service(:oAuth)
  #     @token, @token_secret = @service.get_access_token(@request_token, @request_secret, oauth_verifier)
  #  end
  #
  #  private
  #   def get_token_from_cookie
  #     cookie_token = cookies[:token]
  #     unless cookie_token.nil?
  #       cookie_token = cookie_token.split("|")
  #       if cookie_token.size != 2
  #         raise SyntaxError, "The cookie is not valid"
  #       end
  #       @request_token = cookie_token[0]
  #       @request_secret = cookie_token[1]
  #     end
  #   end

  class Oauth < BaseClient

    AUTHORIZE_URI = "http://connect.bluevia.com/authorise/"

    def initialize(params = nil)
      super(params)
  end
   
    def get_request_token(*_params)
      
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
      if _params.size>1
        Raise ClientError, "Wrong number of arguments"
      end
      if _params.empty? 
        params[:oauth_callback] = "oob"
        uri = AUTHORIZE_URI
      else
        if _params[0].instance_of?(String)
          params[:oauth_callback] = _params[0]
          uri = AUTHORIZE_URI
        elsif _params[0].instance_of?(Hash)
          if _params[0].has_key?(:callback)
            params[:oauth_callback] = _params[0][:callback]
          else
            params[:oauth_callback] ="oob"
          end
          if _params[0].has_key?(:uri)
            uri = _params[0][:uri]
          else
            uri = AUTHORIZE_URI
          end
        end
      end
#      request_token = consumer.get_request_token(params, {:v => "1"}, specific_params)
      request_token = consumer.get_request_token(params)
      if(params[:oauth_callback].to_i==0)
        return request_token.token, request_token.secret, "#{uri}?oauth_token=#{request_token.token}"
      else
        return request_token.token, request_token.secret, ""
      end
    end


    def get_access_token(token, token_secret, oauth_verifier)
      begin
        consumer = OAuth::Consumer.new \
          @consumer_key, @consumer_secret,
          {
            :site               => @@base_uri,
            :signature_method   => "HMAC-SHA1",
            :request_token_path => "#{BASEPATH}/Oauth/getRequestToken",
            :access_token_path  => "#{BASEPATH}/Oauth/getAccessToken",
            :http_method        => :post
          }
        request_token = OAuth::RequestToken.new(consumer, token, token_secret)
        access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)

        return access_token.params[:oauth_token], access_token.params[:oauth_token_secret]
      rescue => ex
        return nil, nil # error
      end
    end
  end
end