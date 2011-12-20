#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia; module Attach
  
#
# Class to hold attachment information for messaging
#
class Attachment
  attr_accessor :filename
  attr_accessor :mimetype
  
  # Valid mimetypes
  @@valid_mimetypes = %W{text/plain image/jpeg image/bmp image/gif image/png audio/amr audio/midi audio/mp3 audio/mpeg audio/wav video/mp4 video/avi video/3gpp}
  
  def initialize( fname, mtype )
    @filename = fname
    unless mtype.nil?
      if @@valid_mimetypes.include?(mtype)
        @mimetype = mtype
      else
	raise SyntaxError, "Type not allowed. #{@@valid_mimetypes} only."
      end
    end
  end
  
end

end; end