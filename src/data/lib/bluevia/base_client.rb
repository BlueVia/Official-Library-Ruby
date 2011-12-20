#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
#require 'net/http/post/multipart'
require 'oauth/client/helper'
require 'multipart_body'
#to_xml
require 'xmlsimple'
require 'active_record'
require 'base64'
require 'securerandom'
require 'time'
%w[attach utils response ext/hash errors bluevia_logger].each{|api|  require "bluevia/#{api}"}


module Bluevia
  #
  # Abstract class that wraps access to REST services
  #

  class BaseClient
    include BlueviaLogger

    attr_accessor :base_uri

    # Base URI to invoke Bluevia API. Production environment
    BASEURI = "https://api.bluevia.com"
    
    # RPC INTERFACE CONFIGURATION
    #
    
    # RPC call version
    RPCVERSIONPARM = "v1"
    
    #
    # REST INTERFACE CONFIGURATION
    #

    # Base Path to invoke Bluevia API. Production environment
    BASEPATH = "/services/REST"
  
    # Default parameters required to invoke API
    DEFAULT_PARAMS = {:version => "v1", :alt => "json"}
    # Endpoint for commercial (either testing or commercial apps)
    BASEPATH_COMMERCIAL = ""
    # Endpoint for sandbox (either testing or commercial apps)
    BASEPATH_SANDBOX    = "_Sandbox"

    # HTTP Proxy is SDK is being used behind a firewall
    PROXY = nil #"localhost:8888" #, "nube.hi.inet:8080"

    def BaseClient.create_rest_client(uri = nil)
      @@base_uri = uri.nil? ? BASEURI : uri
      @@uri = URI.parse(@@base_uri)

      # Set proxy if required
      unless PROXY.nil?
        proxy = PROXY.split(":")
        rest = Net::HTTP::Proxy(proxy[0], proxy[1]).new(@@uri.host, @@uri.port)
      else
        rest = Net::HTTP.new(@@uri.host, @@uri.port)
      end
      # Set HTTP connection with SSL if required
      if @@uri.instance_of?(URI::HTTPS)
        rest.use_ssl = true
      end
      rest.read_timeout=(5)
      rest
    end


    #
    # Creates basic HTTP client
    #
    def initialize(params = nil)
      @@uri = URI.parse(BASEURI)

      if params.nil?
        @rest = BaseClient.create_rest_client
      elsif params.instance_of?(Hash)
        params.has_key?(:rest) and @rest = params[:rest]
        params.has_key?(:logger) and logger = params[:logger]
      else
        @rest = params
      end

      logger.debug "Initialized baseClient for service: #{self.class.name}"
    end

    #
    # set HTTP client
    #
    def set_http_client(rest)
      @rest = rest
    end

    #
    # set the valid timeout for the HTTP requests
    #
    def set_timeout(timeout = 5)
      !timeout.nil? and @rest.read_timeout(timeout)
    end

    #
    # Define an instance variable using the default Hash syntax
    #
    def []=(key, value)
      self.instance_variable_set(:"@#{key}", value) unless key.nil?
    end

    #
    # Creates a valid path by concat the path received
    # with the path defined in BASEPATH
    #
    def set_path(_path = nil)
      path = BASEPATH.clone
      path << _path unless _path.nil?
    end

    #
    # Include params in the URI being created to perform a REST call
    #
    def include_params(_path, _params)
      "#{_path}?".
        concat(
        _params.collect{
          |k,v|
          "#{k}=#{CGI::escape(v.to_s)}"
        }.reverse.join('&')) unless _params.nil?
    end

    # Each Bluevia API has a specific basepath. This method gets the specific
    # service basepath and the path associated to the request (either test or
    # commercial)
    def get_basepath
      begin
        basepath = self.class.const_get("BASEPATH_API")
      rescue NameError => e
        logger.error "Unable to fetch basepath #{e}"
        basepath = "/#{self.class.to_s.upcase}_"
      end

      if @commercial
        path = BASEPATH_COMMERCIAL
      else
        path = BASEPATH_SANDBOX
      end
      "#{basepath}#{path}"
    end

    #
    # Send an Http::Get to the server
    #
    def GET(_path = nil, params = nil, headers = nil, field = nil, use_base_path = true)
      @getresponse = nil
      if use_base_path        
        path = set_path(_path)                
      else
        path = _path
      end     
      params = Hash.new if params.nil?
      params.merge!(DEFAULT_PARAMS) { |key,oldval,newval| oldval }

      path = include_params(path, params)

      logger.debug "GET Request path: " << path

      begin
        resp = authorized_client.get(path, get_headers(headers))
      rescue => e
        logger.error e
      end
      @getresponse = create_response(resp)
      return handle_response(@getresponse, "body", field)
    end

    def get_getresponse()
      @getresponse
    end
    
    #
    #  Send an Http::Post to the server
    #
    def POST(_path = nil, body = nil, headers = nil, files = nil, return_header = nil, use_base_path = true, incl_params = true)      
        #by default adds a basepath
        if use_base_path
          path = set_path(_path)
        else
          path = _path
        end
        #by defaults adds version=1 params
        if incl_params
          path = include_params(path, DEFAULT_PARAMS)
        end
        logger.debug "POST Request path: " << path
        logger.debug "POST body: " << body

        begin
          resp = authorized_client.post(path, body, get_headers(headers, true)) 
        rescue => e
	  logger.error e
        end
	return handle_response(create_response(resp), return_header.nil? ? nil : "headers", return_header)
      end

    #
    # Send an Http::Post::Multipart to the server
    #
    def POST_MULTIPART(_path = nil, message = nil, body = nil, attachments = nil, headers = nil, return_header = nil)

      multipart_data = Array.new

      #process json root info (address, subject, ...)
      multipart_data << Part.new(
        :name => 'root-fields',
        :body => message,
        :content_type => 'application/json'
      )

      #process message body
      unless body.nil?
        multipart_data << Part.new(
          :name => 'body',
          :body => body,
          :content_type => 'text/plain'
        )
      end

      if attachments.is_a?(Attach::Attachment)
        attachments = [attachments]
      end

      #process attachments
      if attachments.is_a?(Array)
        file_id = 0
        attachments.each{|att|
            if File.exists?(att.filename)
#              mime_type     = Utils.get_file_mime_type(file)
#              attachment = File.open(file)
              mime_type = att.mimetype
#              mime_type = mime_type + ";charset=UTF-8\nContent-Transfer-Encoding: base64"
              mime_type = mime_type + ";charset=UTF-8\nContent-Transfer-Encoding: binary"
              attachment = File.open(att.filename, "rb")
#              contents = Base64.encode64(attachment.read)
              contents = attachment.read
              multipart_data << Part.new(
                :name => file_id,
                :body => contents,
                :filename => att.filename,
                :content_type => mime_type
              )
              file_id = file_id + 1
            end
        }
      end

      multipart = MultipartBody.new multipart_data

      logger.debug "sent message: " << multipart.to_s

      path = set_path(_path)
      path = include_params(path, DEFAULT_PARAMS)
      logger.debug "POST Request path: " << path
      
      unless body.nil?
        logger.debug "POST body: " << body
      end
      resp = authorized_client.post(path, multipart.to_s,
        {
          "Content-Type" => "multipart/form-data; boundary=" + multipart.boundary
        }
      )
      return  handle_response(create_response(resp), nil)
    end

    #
    # Send an Http::Delete to the server
    #
    def DELETE(_path = nil, headers = nil)
        path = set_path(_path)
      path = include_params(path, DEFAULT_PARAMS)

      logger.debug "DELETE Request path: " << path

      resp = authorized_client.delete(path, get_headers(headers, false))
      return handle_response(create_response(resp))
    end

    #
    # Generates an authorized oAuth Client    
    def authorized_client
      if @timestamp.nil?
        @consumer ||= OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => @@base_uri)
      else 
        @consumer ||= OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => @@base_uri, :timestamp=> @timestamp.to_i.to_s)
      end
      @access_token ||= OAuth::AccessToken.new(@consumer, @token, @token_secret)
      @access_token
    end

    #
    # Returns true if is two legged
    #
    def is_two_legged      
      two_legs = @token.nil? && @token_secret.nil?
      logger.debug "Application is two legged? " + two_legs.inspect
      
      return two_legs
    end

    #
    # Creates the basic header while creating an HTTP Request
    #
    def get_headers(_headers = nil, is_post = false)

      headers = {
        "Accept" => "application/json"
        }

      if is_post
        headers["Content-Type"] = "application/json"
      end

      unless _headers.nil?
        headers.merge!(_headers) { |key,oldval,newval| newval }
      end
      logger.debug "HEADERS: "
      logger.debug headers
      return headers
    end

    private

    # Converts an HTTP response to an internal object
    def create_response(http_response)
      return nil if http_response.nil?

      response = Response.new
      response.code    = http_response.code
      response.message = http_response.message

      # headers
      response.headers = Hash.new

      http_response.each_header {|key, value|
        response.headers[key] = value
      }

      # body
      begin
        # Convert JSON
        if response.headers["content-type"].to_s.start_with?("application/json")
          unless http_response.body.nil? or http_response.body.empty?
            response.body = JSON.parse(http_response.body)
          else
            response.body = ""
          end
        # Convert XML to Hash
        elsif response.headers["content-type"].to_s.start_with?("application/xml")
          begin
            response.body = Hash.from_xml(http_response.body)
          rescue => e
            logger.error "Unable to decode response: #{e.to_s}"
            raise ServerError, "Unable to decode XML response"
          end
        # Do nothing
        else
          response.body = http_response.body
        end
      rescue => e
        logger.error "Error while converting response"
        logger.error e
        raise ServerError, "Error while processing the response"
      end
      logger.debug response.to_s
      
      return response
    end

    #
    # This method is in charge of verify the code retrieved from the server and
    # handle it properly.
    # In case of get a field, just this JSON filed is retrieved from the body response
    #
    # Examples:
    #
    # response.code = 200
    # response.body = {"name": "foo", "surname": "bar", "age": 32, "address": "Nissim Aloni"}
    #
    # handle_response(response, {"name"}) => "foo"
    # handle_response(response) => {"name": "foo", "surname": "bar", "age": 32, "address": "Nissim Aloni"}
    # handle_response(response, {"age"}) => 32
    #
    def handle_response(response, field_name = nil, field_value = nil)
      unless response.nil?
	if !field_name.nil? && field_value.instance_of?(String)
          field_value = [field_value]
        end

        # Valid response
        if response.code =~ /20?/
          unless field_name.nil?
            response_field = response[field_name]
            if field_value.nil?
              return response_field
            end
            unless response_field.nil?
              if response_field.instance_of?(Hash)
                unless field_value.nil? || !field_value.instance_of?(Array)
                  field_value.each{ |key|
                    unless response_field.has_key?(key)
                      raise ClientError, "Unable to find the request data: #{key}"
                    end
                    response_field = response_field[key]
                  }
                end
                return response_field
              end
            else
              return false
            end
          else
            return response
          end
        # Not found
        elsif response.code.eql?("404")
          raise NotFoundError, "Unable to find the resource: #{response.message} - #{response.body}"
        # 40?
        elsif response.code =~ /40?/
          raise ClientError, "Error #{response.code} received: #{response.message} - #{response.body}"
        # Not implemented
        elsif response.code =~ /501/
          raise NotImplementedError, "Operation not implemented in server side #{response.message} - #{response.body}"
        # Server Error
        elsif response.code =~ /500/
          raise ServerError, "Server error #{response.message} - #{response.body}"
        end
      else
        raise ServerError, "Unable to connect with endpoint."
      end
    end

   def handle_response_RPC(response, field_name = nil, field_value = nil)
      unless response.nil?
        if !field_name.nil? && field_value.instance_of?(String)
          field_value = [field_value]
        end

        # Valid response
        if response.code =~ /20?/ && response.body[:methodResponse].has_key?(:result)
            unless field_name.nil?
              response_field = response[field_name]
              if field_value.nil?
                return response_field
              end
              unless response_field.nil?
                if response_field.instance_of?(Hash)
                  unless field_value.nil? || !field_value.instance_of?(Array)
                    field_value.each{ |key|
                      unless response_field.has_key?(key)
                        raise ClientError, "Unable to find the request data: #{key}"
                      end
                      response_field = response_field[key]
                    }
                  end
                  return response_field
                end
              else
                return false
              end
              
            else
              return response
            end
        # Not found
        elsif response.code.eql?("404")
          raise NotFoundError, "Unable to find the resource: #{response.message}"
        # 40?
        elsif response.code =~ /40?/
          raise ClientError, "Error #{response.code} received: #{response.body[:methodResponse][:error][:code]} - #{response.body[:methodResponse][:error][:message]}"
        # Not implemented
        elsif response.code =~ /501/
          raise NotImplementedError, "Operation not implemented in server side #{response.code} received: #{response.body[:methodResponse][:error][:code]} - #{response.body[:methodResponse][:error][:message]}"
        # Server Error
        elsif response.code =~ /500/
          raise ServerError, "Server error #{response.code} received: #{response.body[:methodResponse][:error][:code]} - #{response.body[:methodResponse][:error][:message]}"

        end
      else
        raise ServerError, "Unable to connect with endpoint."
      end
    end

    def add_oauth(req)
      @consumer.sign!(req, @access_token)      
    end

protected
    def RPC(url, method, request_params = nil)

      headers = {
        "Accept" => "application/xml",
        "Content-Type" => "application/xml"
      }

      unless request_params.nil?
	parsed_params = XmlSimple.xml_out(request_params, {'NoAttr' => true, 'KeepRoot' => true, 'NoIndent' => false })
	block = '<tns:params>' + parsed_params + '</tns:params>'
	parsed_params = block
      else
        parsed_params = ''
      end
      id = SecureRandom.uuid
      # it needs basic namespace definitions
      
       str_call =
           '<?xml version="1.0" encoding="UTF-8"?>' +
           '<tns:methodCall'+
           ' xmlns:tns="http://www.telefonica.com/schemas/UNICA/RPC/payment/v1"'+
           ' xmlns:uctr="http://www.telefonica.com/schemas/UNICA/RPC/common/v1"'+
           ' xmlns:rpc="http://www.telefonica.com/schemas/UNICA/RPC/definition/v1"'+
           ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'+
           ' xsi:schemaLocation="http://www.telefonica.com/schemas/UNICA/RPC/payment/v1'+
           ' UNICA_API_RPC_payment_types_v1_1.xsd">' + 
           '<rpc:id>' + id + '</rpc:id>' + 
           '<rpc:version>' + RPCVERSIONPARM + '</rpc:version>' +
           '<tns:method>' + method + '</tns:method>' +
             parsed_params +
          '</tns:methodCall>'
          
      #POST( @@base_uri + '/services/RPC' + url, str_call.chomp, headers, nil, nil, false, false )
      #def POST(_path = nil, body = nil, headers = nil, files = nil, return_header = nil, use_base_path = true, incl_params = true)      
      #by default adds a basepath
      #if use_base_path
      #    path = set_path(_path)
      #  else
        path = @@base_uri + '/services/RPC' + url
        body= str_call.chomp
        return_header=nil
      #  end
        #by defaults adds version=1 params
      #  if incl_params
      #    path = include_params(path, DEFAULT_PARAMS)
      #  end
        logger.debug "POST Request path: " << path
        logger.debug "POST body: " << body

        begin
          resp = authorized_client.post(path, body, get_headers(headers, true)) 
        rescue => e
    logger.error e
        end
  return handle_response_RPC(create_response(resp), return_header.nil? ? nil : "headers", return_header)
 
    end
  end
end
