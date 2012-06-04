#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

%w[connection_error bluevia_error].each{|file| require "bluevia/errors/#{file}"}


module Bluevia::Errors
  

end
