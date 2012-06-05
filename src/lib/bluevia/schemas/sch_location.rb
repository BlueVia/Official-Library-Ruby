#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module Schemas
    
    #
    # LocationInfo object for Location Client
    # attributes:
    # [*report_status*] Information about location request 
    # [*coordinates_latitude*] 
    # [*coordinates_longitude*] 
    # [*accuracy*] 
    # [*timestamp*] Information about timestamp of the request 
    #
    
    class LocationInfo 
      attr_accessor :report_status, :coordinates_latitude, :coordinates_longitude, :accuracy, :timestamp
      
      def initialize (report_status = nil, coordinates_latitude = nil, coordinates_longitude = nil, accuracy = nil, timestamp = nil)
        @report_status = report_status
        @coordinates_latitude = coordinates_latitude
        @coordinates_longitude = coordinates_longitude
        @accuracy = accuracy
        @timestamp = timestamp
      end
    end
  end
end