#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/serializers/json_serializer'
require 'bluevia/schemas/sch_messaging'
require 'multipart_body'

module Bluevia
  module ISerializer
    #
    # This class implements Multipart serializer and inherits from JSON serializer
    # because message must be json serialized
    # 
   class MultipartSerializer < JsonSerializer
     
     #
     # Serializer method
     # [*entity*]  is an array with message (to be JSON serialized), a body with text information
     #             and an attachment array full of Attachment objects
     # Returns a hash with multipart body and headers
     # Raises BlueviaError if serializing failed
     #
     def serialize(entity)
       
       begin
         message = entity[:message]
         body = entity[:body]
         attachments = entity[:attachment]
        
         json_hash = super(message)
         
         obj = json_hash[:body]
         multipart_data = Array.new

          #process json root info (address, subject, ...)
          multipart_data << Part.new(
            :name => 'root-fields',
            :body => obj,
            :content_type => "application/json;charset=UTF-8\nContent-Transfer-Encoding: binary\nContent-Length:#{obj.length}"
          )
    
          #process message body
          unless body.nil?
            multipart_data << Part.new(
              :name => 'attachments',
              :body => body,
              :filename => 'message.txt',
              :content_type => "text/plain;charset=UTF-8\nContent-Transfer-Encoding: binary\nContent-Length:#{body.length}"
            )
          end
          
          if attachments.is_a?(Bluevia::Schemas::Attachment)
            attachments = [attachments]
          end
    
          #process attachments
          if attachments.is_a?(Array)
            file_id = 0
            attachments.each{|att|
                if File.exist? att.filename
                  mime_type = att.mimetype
                  if mime_type.include? 'text'
                    attachment = File.open(att.filename, "rb")
                    contents = attachment.read
                    mime_type = mime_type + ";charset=UTF-8\nContent-Transfer-Encoding: binary\nContent-Length:#{contents.length}"
                    
                  else
                    attachment = File.open(att.filename, "rb")
                    contents = attachment.read

                    mime_type = mime_type + "\nContent-Transfer-Encoding: binary\nContent-Length:#{contents.length}"
                  end
                  name = att.filename.split(/\//).last
                  multipart_data << Part.new(
                    :name => 'attachment',
                    :body => contents,
                    :filename => name,
                    :content_type => mime_type
                  )

                  file_id = file_id + 1
                end
            }
          end
  
         multipart = MultipartBody.new multipart_data

         encoding = {"Content-Type" => "multipart/form-data; boundary=" + multipart.boundary}
         
         return {:body => multipart.to_s, :encoding=> encoding}
         
       rescue StandardError => oe
         e = Bluevia::Schemas::BVResponse.new
         e.code = Bluevia::BVEXCEPTS[Bluevia::ERR_SER]
         e.message = Bluevia::ERR_SER
         raise Bluevia::BlueviaError.new(e)
       end
     
    end
  end
 end 
end

   