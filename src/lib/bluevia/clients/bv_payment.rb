#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'time'
require 'bluevia/clients/commons/bv_base_client'
require 'bluevia/schemas/sch_payment'
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
  # Bluevia Payment API is a set of functions that enables individual,
  # atomic payments based on input economic information. 
  #
 
  class BVPayment < BVOauthClient
    
    #
    # This class provides access to the set of functions which any user could use to access
    # the Payment service functionality
    # Note that this feature is only available for SANDBOX and LIVE modes.
    #
    # required params :
    # [*mode*]            Communication mechanism to communicate with the gSDP
    #                     BVMode::LIVE (also SANDBOX and TEST available)
    # [*consumer_key*]    Oauth consumer key supplied by the developer.
    # [*consumer_secret*] Oauth consumer secret supplied by the developer.
    #
    # example:
    #   @bc = BVPayment.new(Bluevia::BVMode::LIVE, "XXXXX", "YYYYY") 
    #
  
    def initialize(mode, consumer_key, consumer_secret)
      
      init_untrusted(mode, consumer_key, consumer_secret, nil, nil)
      
      # Setting RPC parser and serializer
      @Is = Bluevia::ISerializer::JsonRpcSerializer.new
      @Ip = Bluevia::IParser::JsonRpcParser.new
      @Ie = Bluevia::IParser::XmlParser.new
      
      # To complete RPC part of the URL
      is_rpc
      
      # No TEST mode allowed
      if mode.eql? TEST
        e = BVResponse.new
        e.code = BVEXCEPTS[ERR_INV]
        e.message = ERR_INV
        raise BlueviaError.new(e)
      elsif mode.eql? SANDBOX
        # To complete mode part of the URL
        is_sandbox("/"+ BP_PAY)
        @b_pay_path = BP_PAY + BASEPATH_SANDBOX 
        
      else 
        @base_uri = @base_uri + "/"+ BP_PAY
        @b_pay_path = BP_PAY
      end
    end
    
    #
    # Gets a RequestToken for a Payment operation
    #
    # required params :
    # [*amount*]      Cost of the digital good being sold, expressed in the minimum fractional monetary unit
    #                 of the currency reflected in the next parameter (to avoid decimal digits). 
    # [*currency*]    Currency of the payment, following ISO 4217 (EUR, GBP, MXN, etc.) 
    # [*name*]        Name of the service for the payment
    # [*service_id*]  ID of the service for the payment
    # optional params :
    # [*callback*]    Endpoint to receive verification url
    #
    # returns an Bluevia::Schemas::RequestToken
    # raise BlueviaError
    #
    
    def get_payment_request_token(amount, currency, name, service_id, callback = "oob")
      
      Utils.check_attribute(amount, ERR_PART1 + " 'amount' " + ERR_PART2)
      Utils.check_attribute(currency, ERR_PART1 + " 'currency' " + ERR_PART2)
      Utils.check_attribute(name, ERR_PART1 + " 'name' " + ERR_PART2)
      Utils.check_attribute(service_id, ERR_PART1 + " 'service_id' " + ERR_PART2)
      plus_one = amount.to_i + 1
      Utils.check_number(plus_one, ERR_PART1 + " 'amount' " + ERR_PART4)
      
      e = BVResponse.new
      e.code = COD_1
      
      # Includes extra oauth headers needed only for payment
      params = Hash.new      
      params[:xoauth_apiName] = @b_pay_path

      if callback.eql? "" or callback.nil?
        callback = "oob"
      end
     
      if  callback.instance_of?(String) and callback.to_i==0
        unless callback[0..3].eql?("http") or callback.eql?("oob")
          e.message = "Wrong callback parameter"
          raise BlueviaError.new(e)
        else 
          params[:oauth_callback] = callback
        end
        
      else 
        e.message = "Callback parameter must be a String"
        raise BlueviaError.new(e)
      end
      
      uri=@auth_uri
      
      # Prepare parameters to be included in oauth signature
      # This information is somehow reflected on access tokens returned for 
      # payment transaction (they must be equal to the ones provided y payment method
      body = Hash.new
      body["serviceInfo.name"] = name
      body["serviceInfo.serviceID"] = service_id
      body["paymentInfo.amount"] = amount
      body["paymentInfo.currency"] = currency
      
      begin
        
        # Calls connector oauth methods
        @payment_request_pair = @Ic.get_request_token(params, body)
        return RequestToken.new(@payment_request_pair, "#{@auth_uri}?oauth_token=#{@payment_request_pair.token}")
      
      rescue ConnectionError => error_p
        e= BVResponse.new
        e.code = error_p.code
        error_parsed = @Ie.parse error_p.additional_data[:body]
        e.message = parse_error(error_parsed)
        raise BlueviaError.new(e)
      end
    
    end 

    #
    # Gets access token and token secret that has to be used in the rest of oAuth headers of the
    # payment api calls 
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

    def get_payment_access_token(oauth_verifier, request_token=nil, request_secret=nil)
      Utils.check_attribute(oauth_verifier, ERR_PART1 + " 'oauth_verifier' " + ERR_PART2)
      
      # If no tokens provided, last ones are used
      if request_token.nil?
        request_token = @payment_request_pair.token
      end
      if request_secret.nil?
        request_secret = @payment_request_pair.secret
      end
      # Calls BVOauthClient get_access_token method
      begin
        access_token = get_access_token(oauth_verifier, request_token, request_secret)
      rescue ConnectionError => error_p
        e= BVResponse.new
        e.code = error_p.code
        error_parsed = @Ie.parse error_p.additional_data[:body]
        e.message = parse_error(error_parsed)
        raise BlueviaError.new(e)
      end
    end
    
    # Set connector session tokens
    def set_token(token)
      Utils.check_attribute(token, ERR_PART1 + " 'token' "+ ERR_PART2)
      e = BVResponse.new
          
      begin
        @Ic.set_token(token)
      rescue StandardError
        e.code = COD_12
        e.message = ERR_PART3 + "set payment tokens."
        raise BlueviaError.new(e)
      end
      
    end
         
    #
    # Orders an economic charge on the user's operator account.
    #
    # required params :
    # [*amount*]      Cost of the digital good being sold, expressed in the minimum fractional monetary unit
    #                 of the currency reflected in the next parameter (to avoid decimal digits). 
    # [*currency*]    Currency of the payment, following ISO 4217 (EUR, GBP, MXN, etc.) 
    # optional params :
    # [*endpoint*]    Endpoint to receive notifications of payment status
    # [*correlator*]  Correlator to receive notifications of payment status
    #
    # returns an PaymentResult object with information about the transaction
    # raise BlueviaError
    #
    
    def payment(amount, currency, endpoint = nil, correlator = nil )     
      
      # Verifies mandatory parameters
      Utils.check_attribute(amount, ERR_PART1 + " 'amount' " + ERR_PART2)
      Utils.check_attribute(currency, ERR_PART1 + " 'currency' " + ERR_PART2)
      plus_one = amount.to_i + 1
      Utils.check_number(plus_one, ERR_PART1 + " 'amount' " + ERR_PART4)
      
      # Prepare payment parameters
      params = Hash.new
      payment_params = Hash.new 
      payment_info = Hash.new
      recreq_info= Hash.new 

      payment_info[:amount] = amount
      payment_info[:currency] = currency
      payment_params[:paymentInfo] = payment_info

      if (!endpoint.nil? and !correlator.nil?)
       recreq_info[:endpoint] = endpoint
       recreq_info[:correlator] = correlator
       payment_params[:receiptRequest] = recreq_info
        
      elsif (!endpoint.nil? and correlator.nil?) or (endpoint.nil? and !correlator.nil?)
         e = BVResponse.new
         e.code = COD_1
         e.message = "Both, endpoint and correlator are not mandatory parameters, but if necessary, they must be provided together."
      
      end
      
      # Sets and Gets timestamp value of connector
      # It will be included both in payment params of the request and 
      # in the oauth special header but with different formats 
      timestamp = @Ic.get_timestamp_payment
      @Ic.set_timestamp
      
      payment_params[:timestamp] = timestamp.utc.iso8601
      
      params[:method] = BP_PAY.upcase 
      params[:params] = {:paymentParams => payment_params}

      response = base_create("/" + BP_PAY.downcase, nil, params, nil)
      return filter_response(BP_PAY.downcase, response)
      
    end # payment

    #
    # Merchant can use this operation instead of payment, 
    # to cancel a previously authorized purchase.
    #
    def cancel_authorization()
      
      method = 'CANCEL_AUTHORIZATION'
      header_method = 'cancelAuthorization'
      params = {:method => method}
      response = base_create("/" + header_method, nil, params, nil)
      
      if response.nil? 
        return true
      else
        return false
      end
      
    end

    #
    # This operation allows to get the status of the current transaction.
    # required params :
    # [*transaction_id*] Transaction identifier returned inside PaymentStatus object
    #                    ex: transaction_id = payment_response.transaction_id
    #
    # returns an PaymentStatus object with information about the transaction
    # raise BlueviaError
    #
     
    def get_payment_status( transaction_id ) 
      Utils.check_attribute(transaction_id, ERR_PART1 + " 'transaction_id' ")
      
      method = 'GET_PAYMENT_STATUS'
      header_method = 'getPaymentStatus'
      params = Hash.new
      params = {:method => method, :params =>{:getPaymentStatusParams => {:transactionId => transaction_id}}}

      response= base_create("/"+ header_method, nil, params, nil)
      return filter_response(header_method, response)
    end
  
  private

    #
    # Auxiliary method to filter both payment and get_payment_status response.
    # Returns PaymentResult object when payment method and PaymentStatus when get_payment_status
    # Returns BlueviaError when filtering failed
    #
    
    def filter_response (header_method, response)
      
      e = BVResponse.new 
      e.code = COD_12
      
      p_stat = PaymentStatus.new
      
      if header_method=='payment'
        begin  
          return PaymentResult.new if response.nil? or !response.instance_of?(Hash)
          
          transaction_id = response['paymentResult']['transactionId']
          p_stat.transaction_status = response['paymentResult']['transactionStatus']
          p_stat.transaction_status_description = response['paymentResult']['transactionStatusDescription']
          p_resp = PaymentResult.new(transaction_id, p_stat)
          return p_resp
        rescue
          e.message = ERR_PART3 + "create PaymentResult."
          raise BlueviaError.new(e)
        end
        
      elsif header_method=='getPaymentStatus'
        begin
          return PaymentStatus.new if response.nil? or !response.instance_of?(Hash)
          
          p_stat.transaction_status = response['getPaymentStatusResult']['transactionStatus']
          p_stat.transaction_status_description = response['getPaymentStatusResult']['transactionStatusDescription']
          return p_stat
        rescue
          e.message = ERR_PART3 + "create PaymentStatus."
          raise BlueviaError.new(e)
        end
        
      end
        
    end
  end
end
