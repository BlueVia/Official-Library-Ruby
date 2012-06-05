#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
require 'time'

require 'oauth'

%w[utils ext/hash errors schemas bluevia_logger].each{|one|  require "bluevia/#{one}"}


module Bluevia
  module IConnector
   #
   # This Class implements http CRUD with oauth protocols for both trusted and untrusted partners
   #
   class BVHttpOAuthConnector 
      include BlueviaLogger
      include Bluevia::Errors
      include Bluevia::Schemas
      
      def initialize (consumer_key, consumer_secret, token_key=nil, token_secret=nil, cert_file=nil, cert_pass = nil)
        
        uri = URI.parse(BASE_URI)
  
        @rest = Net::HTTP.new(uri.host, uri.port)
        
        # Set HTTP connection with SSL if required
        if uri.instance_of?(URI::HTTPS)
          @rest.use_ssl = true
        end
        
        unless cert_file.nil?
          ssl2ways(cert_file, cert_pass)
        end
       
        @rest.read_timeout=(20)


        @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret, :site => BASE_URI)
        
        @consumer.http=@rest
        
        unless token_key.nil? 
          @access ||= OAuth::AccessToken.new(@consumer, token_key, token_secret)
          @access
        else
          @access ||= OAuth::AccessToken.new(@consumer, nil, nil)
          @access
        end
        
        @consumer_key = consumer_key
        @consumer_secret = consumer_secret 
        @token_key = token_key 
        @token_secret = token_secret
          
      end
    
      #
      # Implements HTTP Create CRUD method with OAuth authentication 
      # 
      def create(address, parameters, content, encoding)
        
        path = include_params(address, parameters)
        
        logger.debug "POST Request path: " << path.to_s
        logger.debug "POST body: " << content

        begin
          token = OAuth::Token.new(@token_key, @token_secret)
          @req=@consumer.create_signed_request(:post,path,token,{},content,get_headers(encoding, true))
          return nil if block_given? and yield(@req) == :done
          @generic_response = @consumer.http.request(@req)
         
          if !(headers = @generic_response.to_hash["www-authenticate"]).nil? &&
            (h = headers.select { |hdr| hdr =~ /^OAuth / }).any? &&
            h.first =~ /oauth_problem/
            params = OAuth::Helper.parse_header(h.first)
            raise OAuth::Problem.new(params.delete("oauth_problem"), @generic_response, params)
          end
        rescue StandardError => exc
          e= BVResponse.new
          e.code = COD_13
          e.message = exc.to_s
          
          raise BlueviaError.new(e)

        end

        return handle_response(create_response(@generic_response))
      
      end
      
      #
      # Implements HTTP Retrieve CRUD method with OAuth authentication 
      #    
      def retrieve(address, parameters)
        
        path = include_params(address, parameters)

        logger.debug "GET Request path: " << path

        begin
          token = OAuth::Token.new(@token_key, @token_secret)
          @req=@consumer.create_signed_request(:get,path,token,{},nil,get_headers(nil, false))
          return nil if block_given? and yield(@req) == :done
          @generic_response = @consumer.http.request(@req)

          if !(headers = @generic_response.to_hash["www-authenticate"]).nil? &&
            (h = headers.select { |hdr| hdr =~ /^OAuth / }).any? &&
            h.first =~ /oauth_problem/
            params = OAuth::Helper.parse_header(h.first)
            raise OAuth::Problem.new(params.delete("oauth_problem"), @generic_response, params)
          end
  
        rescue => exc
          e= BVResponse.new
          e.code = COD_13
          e.message = exc.to_s
          
          raise BlueviaError.new(e)

        end
        
        return handle_response(create_response(@generic_response))
        
        
      end
      
      #
      # Implements HTTP Update CRUD method with OAuth authentication
      # NOTE: NOT IMPLEMENTED 
      #    
      def update (address, parameters, content, encoding)
        e= BVResponse.new
        e.code = BVEXCEPTS[ERR_NI]
        e.message = ERR_NI
        raise BlueviaError.new(e)
      end
    
    
      #
      # Implements HTTP Delete CRUD method with OAuth authentication 
      #
      def delete (address, parameters)
        
        path = include_params(address, parameters)

        logger.debug "DELETE Request path: " << path
        
        begin
          token = OAuth::Token.new(@token_key, @token_secret)
          @req=@consumer.create_signed_request(:delete,path,token,{},nil,get_headers(nil, false))
          return nil if block_given? and yield(@req) == :done
          @generic_response = @consumer.http.request(@req)

          if !(headers = @generic_response.to_hash["www-authenticate"]).nil? &&
            (h = headers.select { |hdr| hdr =~ /^OAuth / }).any? &&
            h.first =~ /oauth_problem/
            params = OAuth::Helper.parse_header(h.first)
            raise OAuth::Problem.new(params.delete("oauth_problem"), @generic_response, params)
          end          
        rescue => exc
          e= BVResponse.new
          e.code = COD_13
          e.message = exc.to_s
          
          raise BlueviaError.new(e)

        end
        return handle_response(create_response(@generic_response))
      end
      
      #
      # get_request_token for oauth client
      #

      def get_request_token(params=nil, body = nil)
         consumer ||= OAuth::Consumer.new \
                                                @consumer_key,
                                                @consumer_secret,
                                                { :site               => BASE_URI,
                                                  :signature_method   => "HMAC-SHA1",
                                                  :request_token_path => "/services/REST/Oauth/getRequestToken",
                                                  :access_token_path  => "/services/REST/Oauth/getAccessToken",
                                                  #:proxy              => "http://localhost:8888",
                                                  :http_method        => :post
                                                }

       begin
         
         if body.nil?
          request_token = consumer.get_request_token(params)
        else
          request_token = consumer.get_request_token(params, body)
        end
        
         return request_token
       
       rescue StandardError => oerror
         e = create_error_response(oerror)
         raise ConnectionError.new(e)
       end
     end

      #
      # get_access_token for oauth client
      #
     def get_access_token (request_token, request_secret, oauth_verifier)
       consumer = OAuth::Consumer.new \
          @consumer_key, @consumer_secret,
          {
            :site               => BASE_URI,
            :signature_method   => SIGNATURE,
            :request_token_path => REST_URL + OAUTH_REQUEST,
            :access_token_path  => REST_URL + OAUTH_ACCESS,
            :http_method        => :post
          }
       begin
         request_tok = OAuth::RequestToken.new(consumer, request_token, request_secret)
         access_token = request_tok.get_access_token(:oauth_verifier => oauth_verifier)
         return access_token
       rescue StandardError => oerror
         e = create_error_response(oerror)
         raise ConnectionError.new(e) 
       end
       
     end
     
     #
     # Returns http response before parsing 
     #
     def get_response
       return @generic_response
     end
     
     #
     # Returns http response before parsing 
     #
     def get_request
       return @req

     end
     #
     # Returns token key
     #
     def get_token
       return @token_key
     end
     
     #
     # Re-set consumer an access objects with new tokens (used for payment sessions)
     #
     def set_token (token = nil)
       
         @token_key = token.token
         @token_secret = token.secret
         
         consumer ||= OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => BASE_URI)
         access ||= OAuth::AccessToken.new(consumer, @token_key, @token_secret)
         
         self.instance_variable_set(:@consumer, consumer)
         self.instance_variable_set(:@access, access)
         
     end
     #
     # Re-set consumer an access objects with timestamp
     #
     def set_timestamp
       consumer ||= OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => BASE_URI, :timestamp=> @timestamp.to_i.to_s)
       access ||= OAuth::AccessToken.new(consumer, @token_key, @token_secret)
      
       self.instance_variable_set(:@consumer, consumer)
       self.instance_variable_set(:@access, access)
     end
     def set_trusted_timestamp
       consumer ||= OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => BASE_URI, :timestamp=> @timestamp.to_i.to_s)
       consumer.http=@rest
       access ||= OAuth::AccessToken.new(consumer, @token_key, @token_secret)
      
       self.instance_variable_set(:@consumer, consumer)
       self.instance_variable_set(:@access, access)
     end
     
     def get_timestamp_payment
      
      @timestamp=Time.now
      
     end
    
   private
     
     
      #
      # To create error response
      #
      def create_error_response(oerror=nil)
       
        if oerror.nil?
          return nil
        end
       
        response = BVResponse.new
           
        begin
         
          oerror = oerror.request
           
          response.code    = oerror.code
          response.message = oerror.message
          
          headers = Hash.new
      
          oerror.each_header {|key, value|
            headers[key] = value
          }
  
          response.additional_data    = {:body => oerror.body, :headers => headers}
          
        rescue StandardError => err
          e = BVResponse.new
          e.code = COD_13
          e.message = err.to_s
          raise BlueviaError.new(e) 
          
        end
         return response
     
      end
      
      #
      # Reads cert_file with or without password and includes it in the request
      #
      def ssl2ways (cert_file, cert_pass = nil) 
         
          @rest.verify_mode = OpenSSL::SSL::VERIFY_PEER
            
          File.open(cert_file) do |cert|
          key_data = cert.read
          if(key_data.include?("KEY"))
               
            @rest.cert = OpenSSL::X509::Certificate.new(key_data)
            if !cert_pass.nil?
              @rest.key = OpenSSL::PKey::RSA.new(key_data, cert_pass)
            else
              @rest.key = OpenSSL::PKey::RSA.new(key_data, nil)
            end
          else
            @rest.cert = OpenSSL::X509::Certificate.new(key_data)
          end
  
          logger.info key_data
          
          end

      end

      
      #
      # Creates the basic header while creating an HTTP Request
      #
      def get_headers(_headers = nil, is_post = false)
  
        headers = {
          "Accept" => "application/json"
          }
  
        if is_post
          headers.merge!(_headers) { |key,oldval,newval| newval }
        end
        logger.debug "HEADERS: "
        logger.debug headers
        return headers
      end
    
      #
      # Include params in the URI being created to perform a call
      #
      def include_params(_path, _params)
        unless _params.nil?
          "#{_path}?".
          concat(
          _params.collect{
            |k,v|
            "#{k}=#{CGI::escape(v.to_s)}"
          }.reverse.join('&'))
        else
          _path
        end
        
      end
      
    #
    # This method is in charge of verify the code retrieved from the server and
    # handle it properly¡
    #

    def handle_response(response)
      unless response.nil?
        # Valid response
        if response.code =~ /20?/
          return response

        # 40?
        elsif response.code =~ /40?/
          raise ConnectionError.new(response)           
        # 30? 
        elsif response.code =~ /30?/
          if response.additional_data.has_key? :headers and response.additional_data[:headers]['Location']!=nil
            p 'Redirected to: ' + response.headers['Location']
            redirectUrl=response.headers['Location']
          end  
        # Server Error
        elsif response.code =~ /50?/
          raise ConnectionError.new(response) 
        end
      else
        e= BVResponse.new
        e.code = BVEXCEPTS[ERR_CON]
        e.message = ERR_CON
        raise BlueviaError.new(e)
      end
    end

      #
      # Converts an HTTP response to an BVResponse object
      #
      def create_response(http_response)
         
         if http_response.nil?
           return nil
         end
         
          response = BVResponse.new
          response.code    = http_response.code
          response.message = http_response.message
          
          headers = Hash.new
    
          http_response.each_header {|key, value|
            headers[key] = value
          }

          response.additional_data    = {:body => http_response.body, :headers => headers}
    
          # headers

          return response
        end

   end 

  end
end
