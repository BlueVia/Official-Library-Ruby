#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'bluevia/schemas/payment_types'
require 'time'

module Bluevia
  #
  # This class is in charge of access Bluevia Directory API
  #

  class Payment < BaseClient
    include Schemas::Payment_types
    
    # Base Path for Location API
    BASEPATH_API = "/Payment"

    def initialize(params=nil)
      super(params)
    end
    
    #
    # Gets request token, secret and uri for user validation using the specific
    # oauth client for payment
    # [*params*] hash object :
    #      required params :
    #          :paymentInfo => <PaymentInfoType>
    #          :name => SERVICEINFO_NAME,
    #          :serviceID => SERVICEINFO_SERVICEID
    #      optional params:
    #          :callback => "oob" (or actual callback url)   
    #
    
    def get_payment_request_token (params)
      oauthbc = BlueviaClient.new(
      { :consumer_key   => @consumer_key,
        :consumer_secret=> @consumer_secret,
        :token          => "",
        :token_secret   => "",
        :uri            => @@base_uri
      })
      if @commercial
	   oauthbc.set_commercial
      else
	   oauthbc.set_sandbox
      end
      service = oauthbc.get_service(:oauth_payment)
      
      @payment_request_token, @payment_request_secret, @payment_validation_url = service.get_request_token params
    end #get_payment_request_token

    def request_token
      @payment_request_token
    end
    def request_secret
      @payment_request_secret
    end
    def validation_url
      @payment_validation_url
    end
    def request_timestamp
      @timestamp=Time.now
    end

    #
    # Gets access token and token secret that has to be used in the rest of oAuth headers of the
    # payment api calls 
    # [*params*] hash object :
    #      required params :
    #          :pin => USER_PIN_CODE
    #      optional params :
    #          :token => REQUEST_TOKEN,
    #          :token_secret => REQUEST_TOKEN_SECRET
    #
    def get_payment_access_token (params)
      oauthbc = BlueviaClient.new(
      { :consumer_key   => @consumer_key,
        :consumer_secret=> @consumer_secret,
        :token          => "",
        :token_secret   => "",
        :uri            => @@base_uri
      })
      if @commercial
        oauthbc.set_commercial
      else
        oauthbc.set_sandbox
      end
      service = oauthbc.get_service(:oauth)
      if params.has_key?(:pin)
        pin = params[:pin]
      else
        raise ClientError, "pin parameter must be provided"
      end
      if params.has_key?(:token)
        token = params[:token]
      else
        token = request_token
      end
      if token.nil?
        raise ClientError, "token parameter must be provided, or alternatively launch get_payment_request_token method first"
      end
      if params.has_key?(:token_secret)
        token_secret = params[:token_secret]
      else
        token_secret = request_secret
      end
      if token_secret.nil?
        raise ClientError, "token_secret parameter must be provided, or alternatively launch get_payment_request_token method first"
      end
      @token, @token_secret = service.get_access_token( token, token_secret, pin)
    end
         
    #
    # Allows to request a charge to the account indicated by the end user identifier
    # [*_params*] hash object :
    #      required params :
    #          :paymentInfo => <PaymentInfoType>
    #      optional params :
    #          :timestamp => Time.now.utc.localtime (optional) 
    #          :end_user_identifier => <UserIdType> (optional, only alias type allowed)
    #          :endpoint => ENDPOINT_URL (optional)
    #          :correlator => CORRELATOR (optional)
    #
    # [*PaymentResultType*] or exception are returned if transaction was sucessfull or not 
    #

    def payment( _params )           
      if _params.has_key?(:paymentInfo)
        unless _params[:paymentInfo].amount.nil?
          amount = _params[:paymentInfo].amount
        else
          raise ClientError, "Amount parameter must be provided"
        end
        unless _params[:paymentInfo].currency.nil?
          currency = _params[:paymentInfo].currency
        else
          raise ClientError, "Currency parameter must be provided"
        end        
      else
        raise ClientError, "Payment information must be provided"
      end
      if (_params.has_key?(:endpoint)&&!_params.has_key?(:correlator))
         raise ClientError, "If endpoint is provided then correlator value must be included too"
      else
        if (!_params.has_key?(:endpoint)&&_params.has_key?(:correlator))
          raise ClientError, "If correlator is provided then endpoint value must be included too"
        end
      end
      

      method = 'PAYMENT'

      payment_params = Hash.new 
      payment_info = Hash.new
      recreq_info= Hash.new 
      
      payment_info['tns:amount'] = amount
      payment_info['tns:currency'] = currency

       if _params.has_key?(:end_user_identifier)
         payment_info['tns:endUserIdentifier'] = _params[:end_user_identifier]
       end
        
       if _params.has_key?(:endpoint)
         recreq_info['uctr:endpoint'] = _params[:endpoint] 
       end
        
       if _params.has_key?(:correlator)
         recreq_info['uctr:correlator'] = _params[:correlator]
       end
        
       unless _params.has_key?(:timestamp)
         request_timestamp
       else
         @timestamp = _params[:timestamp]
       end
       
       payment_params['tns:timestamp'] = @timestamp.utc.iso8601
       payment_params['tns:paymentInfo'] = payment_info
       if _params.has_key?(:endpoint) 
         payment_params['tns:receiptRequest']= recreq_info
       end
       
        
       ## initialize final object
       params  = { 'tns:paymentParams' => payment_params }
       header_method = 'payment'
       response = self._rpc_request(header_method, method, params)
       return filter_response(header_method, response)
    end # payment

    #
    # Merchant can use this operation instead of payment,
    # to cancel a previously authorized purchase.
    #
    def cancel_authorization()
        method = 'CANCEL_AUTHORIZATION'
        header_method = 'cancelAuthorization'
        self._rpc_request(header_method, method)
    end

    #
    # This operation allows to get the status of the current transaction.
    # [*transaction_id*] Transaction identifier returned inside PaymentResultType
    # [*GetPaymentStatusResultType*] or exception are returned 
    #
     
    def get_payment_status( transaction_id ) 
      method = MethodType::GET_PAYMENT_STATUS
      header_method = 'getPaymentStatus'
      params = {'tns:getPaymentStatusParams' => {'tns:transactionId' => transaction_id}}
      response= self._rpc_request(header_method, method, params)
      return filter_response(header_method, response)
    end
     
    def filter_response (header_method, response)
      
      if header_method=='payment'
        id = response.body[:methodResponse][:result][:paymentResult][:transactionId]
        status= response.body[:methodResponse][:result][:paymentResult][:transactionStatus]
        desc= response.body[:methodResponse][:result][:paymentResult][:transactionStatusDescription]
        resp =Schemas::Payment_types::PaymentResultType.new(id,status,desc)
      
      elsif header_method=='getPaymentStatus'
        status=response.body[:methodResponse][:result][:getPaymentStatusResult][:transactionStatus]
        desc= response.body[:methodResponse][:result][:getPaymentStatusResult][:transactionStatusDescription]
        resp =Schemas::Payment_types::GetPaymentStatusResultType.new(status,desc)
      end
      
      return resp
        
    end
    
    
    protected
    def _rpc_request(header_method, method, request_params = nil)
      RPC( "#{get_basepath}/#{header_method}", method, request_params)
    end
   end # payment 
end # Bluevia