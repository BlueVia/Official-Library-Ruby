#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module ISerializer
     
    #
    # This class implements Url Encoded serializer 
    #   
    class UrlEncodedSerializer
      
      #
      # Serializer method
      # [*entity*]  is a hash with parameters to be url encoded
      # Returns a hash with body and headers for the request 
      # Raises BlueviaError if serializing failed
      #
      def serialize(entity)
        begin
          message = entity.collect{|k,v| "#{k}=#{CGI::escape(v.to_s)}"}.join('&')
          encoding = {"content-type" => "application/x-www-form-urlencoded"}
          return {:body => message.to_s, :encoding=> encoding}
        rescue
          e = Bluevia::Schemas::BVResponse.new
          e.code = Bluevia::BVEXCEPTS[Bluevia::ERR_SER]
          e.message = Bluevia::ERR_SER
          raise Bluevia::BlueviaError.new(e)
            
        end
      end
    end
  end
end