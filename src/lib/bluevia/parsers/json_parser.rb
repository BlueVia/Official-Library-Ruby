#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module IParser
  
    #
    # This class implements JSON parser
    #     
    class JsonParser 
      
      #
      # This method parses JSON streams in answer's body
      # Returns a Hash with JSON information or an empty string if stream is empty 
      # Raises BlueviaError when parsing failed
      #
      def parse stream
      
        begin
          unless stream.nil? or stream.empty?
            entity = JSON.parse(stream)
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
    #
    # This class implements RPC parser only for JSON 
    # 
    class JsonRpcParser < JsonParser
      #
      # This method extract information in methodResponse envelope 
      # in both cases result or error returned 
      # Returns a Hash with information or an empty string if stream is empty 
      # Raises BlueviaError when parsing failed
      #
      def parse stream

        entity = super(stream)                  
        if entity.has_key? 'methodResponse' 
          if entity['methodResponse'].has_key?'result'
            entity = entity['methodResponse']['result']
            
            return entity
          elsif entity['methodResponse'].has_key?'error'
            entity = entity['methodResponse']['error']
            return entity
          else
            return nil
          end
        else
          e = Bluevia::Schemas::BVResponse.new
          e.code = Bluevia::BVEXCEPTS[Bluevia::ERR_PARS]
          e.message = Bluevia::ERR_PARS
          raise Bluevia::BlueviaError.new(e)
        end
        
      end #parse_stream
    end#class
  end
end