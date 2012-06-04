#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#
%w[multipart_parser json_parser xml_parser].each{|file|  require "bluevia/parsers/#{file}"}


module Bluevia
  module IParser
   
  end
end 
