#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'rack'
require 'bluevia/parsers/json_parser'

module Rack
 #
 # Code inyection in Rack::Multipart::Parser class, get_data method
 # Normal Rack method does not return the required content_type information
 # when the chunk to parse does not have the filename in the attachments
 # 
module Multipart
    class Parser
      def get_data(filename, body, content_type, name, head)
        data = nil
        if filename == ""
          # filename is blank which means no file has been selected
          return data
        elsif filename
          body.rewind

          # Take the basename of the upload's original filename
          # This handles the full Windows paths given by Internet Explorer
          # (and perhaps other broken user agents) without affecting
          # those which give the lone filename
          filename = filename.split(/[\/\\]/).last

          data = {:filename => filename, :type => content_type,
                  :name => name, :tempfile => body, :head => head}
        elsif !filename && content_type && body.is_a?(IO)
          body.rewind

          # Generic multipart cases, not coming from a form
          data = {:type => content_type,
                  :name => name, :tempfile => body, :head => head}
  
        elsif !filename && content_type
          data = {:type => content_type,
                  :name => name, :tempfile => body, :head => head}    
        else
          data = body
        end

        [filename, data]  
      end
    end
  end
end

module Bluevia
  module IParser
    
    include Rack::Utils::Multipart
    #
    # This class implements Multipart parser and inherits from JSON parser
    # because json body is returned
    # 
    class MultipartParser < JsonParser
      
      #
      # This method parses Multipart messages using rack
      # Returns an array that includes json parsed message 
      # and an array full of MimeContent objects with every attachment
      # Raises BlueviaError when parsing failed
      #       
      def parse stream
        
        begin
          
          c_type = Utils.filter_header(stream, 'content-type')
          c_length = Utils.filter_header(stream, 'content-length')
          
          if c_length.nil?
            c_length = stream.additional_data[:body].length
          end
          cio = StringIO.new("")
          cio = stream.additional_data[:body]
          options = {"CONTENT_TYPE" => c_type, "CONTENT_LENGTH" => c_length, :input => cio}
          env = Rack::MockRequest.env_for("/", options)
          # First parsing to get root-fields separately with json body
          params = Rack::Utils::Multipart.parse_multipart(env)
          json = params['root-fields'][:tempfile]
          # json parsing through parse method of father class
          json = super(json)
          
          st = params['attachments'][:tempfile].to_s    
          ctype = params['attachments'][:type]
          cio = params['attachments'][:tempfile]
          
          clength = st.length
          options = {"CONTENT_TYPE" => ctype, "CONTENT_LENGTH" => clength, :input => cio}
          env = Rack::MockRequest.env_for("/", options)
          # Second parsing to get every attachment separately
          att_parsed = Rack::Utils::Multipart.parse_multipart(env)
          # returns every attachemnt in a Bluevia::Schemas::MimeContent object
          attachments = parse_attachments(att_parsed)
          
          return [json, attachments]
          
        rescue => error
          e = Bluevia::Schemas::BVResponse.new
          e.code = COD_12
          e.message = ERR_PART3 + "parse Multipart content."
          raise BlueviaError.new(e)
        end
        
      end
      
      #
      # Filters parsed object to fill an array full of MimeContent objects 
      # (see Bluevia::Schemas::MimeContent for more information)
      #
      def parse_attachments (attachments)
        atts = Array.new
        
        attachments.each{|k,v|
          aux = Bluevia::Schemas::MimeContent.new
        
          c_transfer = v[:head].split(' ')
          c_transfer.each_index{|m|
            if c_transfer[m].include? "Content-Transfer-Encoding"
              aux.encoding= c_transfer[m+1]
            end
          }          
          aux.content_type = v[:type]
          aux.name = v[:name]
          aux.content = v[:tempfile]
          
          atts<<aux
        }
        return atts
      end
    
        

    
    end

  end
end
