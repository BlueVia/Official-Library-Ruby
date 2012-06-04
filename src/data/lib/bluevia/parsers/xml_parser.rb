#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia

  module IParser
    #
    # This class implements XML parser
    #
    class XmlParser
      
      #
      # This method parses XML streams in answer's body
      # Returns a Hash with XML information or an empty string if stream is empty 
      # Raises BlueviaError when parsing failed
      #
      def parse stream
        begin
          unless stream.nil? or stream.empty?
            entity = Hash.from_xml(stream)
          else
            entity = ""
          end
        rescue 
          e = Bluevia::Schemas::BVResponse.new
          e.code = Bluevia::BVEXCEPTS[Bluevia::ERR_PARS]
          e.message = Bluevia::ERR_PARS
          raise Bluevia::BlueviaError.new(e)

        end

        return entity

      end
    end
  end
end