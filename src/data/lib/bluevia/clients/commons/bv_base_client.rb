#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

%w[iconnector iserializer iparser schemas utils errors bluevia_logger].each{|file| require "bluevia/#{file}"}
require 'bluevia/schemas/sch_response'

module Bluevia
  
  #
  # This class is father of all API clients and implements common part of all of them.
  # Every method calls one of the CRUD methods implemented on IConnector module, 
  # also calls if necessary ISerializers and IParsers for every operation. 
  #  
  
  class BVBaseClient
    include BlueviaLogger
    include IConnector
    include ISerializer
    include IParser 
    include Schemas
    
private

    #
    # Auxiliary method to set SDK main objects for untrusted partners
    #
    
    def init_untrusted (mode, consumer_key, consumer_secret, token_key=nil, token_secret=nil)
     
      bv_init(mode, consumer_key, consumer_secret)
      
      # Depending on 2-legged or 3-legged creates BVHttpOAuthConnector in a different way
      if token_key.nil? and token_secret.nil?
        @Ic= BVHttpOAuthConnector.new(consumer_key, consumer_secret)
      elsif not token_key.nil? and not token_secret.nil?
        @Ic= BVHttpOAuthConnector.new(consumer_key, consumer_secret, token_key, token_secret)
      else
        e = BVBVResponse.new
        e.code = BVEXCEPTS[ERR_TK]
        e.message = ERR_TK
        raise BlueviaError.new(e)
      end
      
    end
    
    #
    # Auxiliary method to set SDK main objects for trusted partners
    #
    
    def init_trusted (mode, consumer_key, consumer_secret, cert_file, cert_pass)
      
      # Checks for cert_file mandatory params (only for trusted partners)
      Utils.check_attribute "cert_file", ERR_PART1 + " 'cert_file' " + ERR_PART2
      # Checks for common mandatory parameters (trusted and untrusted) 
      bv_init(mode, consumer_key, consumer_secret)
      
      # Creates BVHttpOAuthConnector for trusted partners
      @Ic= BVHttpOAuthConnector.new(consumer_key, consumer_secret, nil, nil, cert_file, cert_pass)
    end
    
    #
    # Common Create method called from API clients
    #
    # params :
    # [*address*]     fragment of the URL for the request (specific for every API method) 
    # [*parameters*]  params for the request (specific for every API method) 
    # [*content*]     hash with elements to be serialized and then included in the request
    # [*headers*]     special headers (not the common ones returned from serializer)
    #
    # This method , common url fragment (join it with the method-specific one) 
    #
    
    def base_create(address, parameters, content, headers) 
      # Join method-specific parameters with the common ones (alt and version)
      parameters = Hash.new if parameters.nil?
      parameters.merge!(DEFAULT_PARAMS) { |key,oldval,newval| oldval }
      
      # Complete uri (common and method-specific fragments)
      uri = @base_uri + address
      #logger.debug uri
      begin      
        # If serializer is needed (not nil) the serialize content
        # else body is empty and default headers are set
        unless @Is.nil?
          @Ia = @Is.serialize(content)
          
        else
          @Ia = {:body => nil, :encoding =>  {"Content-Type" => "application/json;charset=UTF-8"}}
        end
        # If special headers to included, merge is done here
        unless headers.nil?
          headers_full = @Ia[:encoding]
          headers_full = headers_full.merge(headers)
          @Ia[:encoding]= headers_full
        end
        # Create method from IConnector CRUD is called 
        @Ir = @Ic.create(uri, parameters, @Ia[:body], @Ia[:encoding])
        
        # To get request/response logger info
        get_log_info
        
        # If parser exists then parses answer's body and returns it
        # else return nil (usually needed when information comes in the headers)
        # Api client use to parse headers when nil is returned
        unless @Ip.nil?
          parsed = @Ip.parse(@Ir.additional_data[:body])
          #logger.debug parsed.to_s
          return parsed 
        else
          return nil
        end
        
      rescue ConnectionError => ie
        @Ir = ie
        # More information about failure is included on the body 
        # and so body is parsed an BlueviaError (with parsed information) is raised
        error_parsed = @Ip.parse(ie.additional_data[:body])
        # Compose BlueviaError message ...
        @Ir.message = parse_error(error_parsed)
        # ... and raise it 
        raise BlueviaError.new(@Ir)  
      rescue BlueviaError => e
        # If already a BlueviaError was raised then expand it
        raise BlueviaError.new(e)
      end
    end
    
    #
    # Common Retrieve method called from API clients
    #
    # params :
    # [*address*]     fragment of the URL for the request (specific for every API method) 
    # [*parameters*]  params for the request (specific for every API method) 
    #
    # This method , common url fragment (join it with the method-specific one) 
    #
    
    def base_retrieve(address, parameters) 

      # Join method-specific parameters with the common ones (alt and version)
      parameters = Hash.new if parameters.nil?
      parameters.merge!(DEFAULT_PARAMS) { |key,oldval,newval| oldval }
      
      # Complete uri (common and method-specific fragments)
      uri = "#{@base_uri}"+address
      #logger.debug uri
      # No serializer is needed 
      # Retrieve method from IConnector CRUD is called directly
      begin
        @Ir = @Ic.retrieve(uri, parameters)
        
        # To get request/response logger info
        get_log_info
      
        # If parser exists then parses answer's body and returns it
        # In case multipart parser full response is parsed (info of headers is required)         
        # If no parser then return nil (usually needed when final information comes in the headers)
        # Api client use to parse headers when nil is returned
        unless @Ip.nil?
          if @Ip.instance_of? MultipartParser
            parsed = @Ip.parse(@Ir)
            
          else
            parsed = @Ip.parse(@Ir.additional_data[:body]) 
            
          end
          return parsed 
        else
          return nil
        end
        
      rescue ConnectionError => ie
        # More information about failure is included on the body 
        # and so body is parsed an BlueviaError (with parsed information) is raised
        @Ir = ie
        error_parsed = @Ip.parse(ie.additional_data[:body])
        @Ir.message = parse_error(error_parsed)
        raise BlueviaError.new(@Ir)  

      end
    end
    
    #
    # Common Update method called from API clients (NOT IMPLEMENTED)
    #
    # params :
    # [*address*]     fragment of the URL for the request (specific for every API method) 
    # [*parameters*]  params for the request (specific for every API method) 
    # [*content*]     hash with elements to be serialized and then included in the request
    # [*headers*]     special headers (not the common ones returned from serializer)
    #
    
    def base_update(address, parameters, content, headers) 
      e= BVResponse.new
      e.code = BVEXCEPTS[ERR_NI]
      e.message = ERR_NI
      raise BlueviaError.new(e)
        
    end

    #
    # Common Delete method called from API clients
    #
    # params :
    # [*address*]     fragment of the URL for the request (specific for every API method) 
    # [*parameters*]  params for the request (specific for every API method) 
    #
    # This method , common url fragment (join it with the method-specific one) 
    #
    
    def base_delete(address, parameters) 

      # Join method-specific parameters with the common ones (alt and version)
      parameters = Hash.new if parameters.nil?
      parameters.merge!(DEFAULT_PARAMS) { |key,oldval,newval| oldval }
      
      # Complete uri (common and method-specific fragments)
      uri = "#{@base_uri}"+address
      #logger.debug uri
      begin    
        # Delete method from IConnector CRUD is called directly
        # No Parser or Serializer are needed
        @Ir = @Ic.delete(uri, parameters)
        
        # To get request/response logger info
        get_log_info
       
      rescue ConnectionError => ie
        # More information about failure is included on the body 
        # and so body is parsed an BlueviaError (with parsed information) is raised
        @Ir = ie
        error_parsed = @Ip.parse(ie.additional_data[:body])
        @Ir.message = parse_error(error_parsed)
        raise BlueviaError.new(@Ir)  

      end
    end
    
    def get_log_info
      
        # Logger information
        logger.debug "REQUEST:"
        req = @Ic.get_request
        logger.debug "path:"
        logger.debug req.path
        logger.debug "method:"
        logger.debug req.method
        logger.debug "body:"
        logger.debug req.body
        
        logger.debug "RESPONSE:"
        resp = @Ic.get_response
        logger.debug "body:"
        logger.debug resp.body
        
    end
    
    #
    # Auxiliary method to fill REST fragment of the URL
    #
    
    def is_rest
      @base_uri = @base_uri + REST_URL
    end
    
    #
    # Auxiliary method to fill RPC fragment of the URL
    #    
    
    def is_rpc 
      @base_uri = @base_uri + RPC_URL
    end

    #
    # Auxiliary method to fill SANDBOX fragment of the URL (if mode is SANDBOX)
    #   
 
    def is_sandbox(uri)
      @base_uri = @base_uri + uri + BASEPATH_SANDBOX
    end
    
    #
    # Checks for mandatory parameters for both 2-legged or 3-legged and mode
    # and also depending on mode value choose the appropriate auth_uri
    #
    
    def bv_init(mode, consumer_key, consumer_secret)

      Utils.check_attribute consumer_key, ERR_PART1 + " 'consumer_key' " + ERR_PART2
      Utils.check_attribute consumer_secret, ERR_PART1 + " 'consumer_secret' " + ERR_PART2
      Utils.check_attribute mode, ERR_PART1 + " 'mode' " + ERR_PART2
      
      case mode
        when LIVE
          @auth_uri= AUTH_URI_LIVE
        when TEST 
          @auth_uri= AUTH_URI_TEST
        when SANDBOX
          @auth_uri= AUTH_URI_SANDBOX
        else
          e= BVResponse.new
          e.code = BVEXCEPTS[ERR_MOD]
          e.message = ERR_MOD
          raise BlueviaError.new(e) 
      
      end

      @Is = @Ip = @Ia = nil
      @Ic = nil 
      @mode = mode
      @Ir= BVResponse.new
      # Init @base_uri
      @base_uri = BASE_URI 
      
    end
    
    #
    # Auxiliary method to create BlueviaError message after parsing exception body
    #
    
    def parse_error (error_parsed)

      if error_parsed.has_key?:ClientException
        return "#{@Ir.message} #{error_parsed[:ClientException][:exceptionCategory]} #{error_parsed[:ClientException][:exceptionId]} #{error_parsed[:ClientException][:text]}"
      elsif error_parsed.has_key?'ClientException'
        return "#{@Ir.message} #{error_parsed['ClientException']['exceptionCategory']} #{error_parsed['ClientException']['exceptionId']} #{error_parsed['ClientException']['text']}"
      elsif error_parsed.has_key?:ServerException
        return "#{@Ir.message} #{error_parsed[:ServerException][:exceptionCategory]} #{error_parsed[:ServerException][:exceptionId]} #{error_parsed[:ServerException][:text]}"
      elsif error_parsed.has_key?'ServerException'
        return "#{@Ir.message} #{error_parsed['ServerException']['exceptionCategory']} #{error_parsed['ServerException']['exceptionId']} #{error_parsed['ServerException']['text']}"
      elsif error_parsed.has_key?:message and error_parsed.has_key?:code
        return "#{@Ir.message} #{error_parsed[:code]} - #{error_parsed[:message]}"
      elsif error_parsed.has_key?'message' and error_parsed.has_key?'code'
        return "#{@Ir.message} #{error_parsed['code']} - #{error_parsed['message']}"
      else
        return "#{@Ir.message}"
      end
    end


  end
end #module Bluevia
