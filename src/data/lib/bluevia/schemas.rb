#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

%w[sch_advertising sch_directory sch_location sch_messaging sch_oauth sch_payment sch_response].each{|file|  require "bluevia/schemas/#{file}"}

module Bluevia

  module Schemas
  end
end