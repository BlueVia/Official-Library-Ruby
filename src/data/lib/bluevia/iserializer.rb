#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

%w[json_serializer multipart_serializer url_encoded_serializer].each{|file|  require "bluevia/serializers/#{file}"}


module Bluevia
  module ISerializer
    
  end
end