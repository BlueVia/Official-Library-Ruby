#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module Schemas
  
    #
    # DeliveryInfo object for messaging APIs 
    # attributes:
    # [*destination*] Destination phone number  
    # [*status*] Delivery status of the message 
    # [*status_description*] Short description about status code  
    #
    class DeliveryInfo 
      attr_accessor :destination, :status, :status_description
      
      def initialize (destination = nil, status = nil, status_description=nil)
        @destination = destination
        @status = status
        @status_description = status_description
      end
    end
    
    #
    # SmsMessage object for SMS APIs 
    # attributes:
    # [*destination*] Destination phone number  
    # [*message*] SMS content 
    # [*origin_address*] Origin address or phone number 
    # [*date*] Information about sending date
    #
    class SmsMessage 
      attr_accessor :destination, :message, :origin_address, :date
      
      def initialize (destination = [], message = nil, origin_address = nil, date = nil)
        @destination = destination
        @message = message
        @origin_address = origin_address
        @date = date
      end
    end
    
    #
    # MmsMessage object for MMS APIs 
    # attributes:
    # [*mms_info*] MmsMessageInfo containing mms information 
    # [*attachments*] MimeContent Array
    # 
    class MmsMessage 
      attr_accessor :mms_info, :attachments
      
      def initialize (mms_info = nil, attachments = [])
        @mms_info = mms_info
        @attachments =attachments
      end
      
    end
    
    #
    # MmsMessageInfo object for MMS APIs 
    # attributes:
    # [*message_id*] Mms id for future request for information 
    # [*destination*] Destination number
    # [*subject*] Mms subject
    # [*origin_address*] Origin address
    # [*date*] Information about sending date
    # [*attachments*] Array of AttachmentInfo objects
    # 
    
    class MmsMessageInfo
      attr_accessor :message_id, :destination, :subject, :origin_address, :date, :attachment_URLs
    
      def initialize (message_id = nil, destination = [], subject = nil, origin_address = nil, date = nil, attachment_URLs = [])
        @message_id = message_id
        @destination = destination
        @subject = subject
        @origin_address = origin_address
        @date = date
        @attachment_URLs = attachment_URLs
      end
    
    end
    
    #
    # AttachmentInfo object for MMS APIs 
    # attributes:
    # [*url*] url to retrieve individual attachmente 
    # [*content_type*] content_type of the attachment 
    # 
    
    class AttachmentInfo
      attr_accessor :url, :content_type
     
      def initialize(url = nil, content_type = nil)
        @url = url
        @content_type = content_type
      end
    end
    #
    # Attachment object for MMS APIs 
    # attributes:
    # [*filename*] Absolute path of the file to be attach
    # [*mimetype*] mime type of the attachment (only from @@valid_mimetypes)
    #
    
    class Attachment
      attr_accessor :filename
      attr_accessor :mimetype
      
      # Valid mimetypes
      @@valid_mimetypes = %W{text/plain image/jpeg image/bmp image/gif image/png audio/amr audio/midi audio/mp3 audio/mpeg audio/wav video/mp4 video/avi video/3gpp}
      
      def initialize(fname, mtype)
        @filename = fname
        unless mtype.nil?
          if @@valid_mimetypes.include?(mtype)
            @mimetype = mtype
          else
            e = Bluevia::Schemas::BVResponse.new
            e.code = COD_1
            e.message = "Invalid 'mimetype' param"
            raise Bluevia::BlueviaError.new(e)
          end
        end
      end
      
    end
  
    #
    # MimeContent object for MMS attachments
    # attributes:
    # [*content*] Attachment content (text, music...)
    # [*content_type*] Content type of the attachment
    # [*encoding*] When returned content of content-transfer-encoding header
    # [*name*] Name of the attachment file
    #
    
    class MimeContent
      attr_accessor :content, :content_type, :encoding, :name
      
      def initialize (content = nil, content_type = nil, encoding = nil, name = nil)
        @content = content
        @content_type = content_type
        @encoding = encoding
        @name = name
      end
    end

  end
end