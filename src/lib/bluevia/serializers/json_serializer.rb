#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'json'

module Bluevia
  module ISerializer
    
    #
    # This class implements JSON serializer
    #
    
    class JsonSerializer

      #
      # Serializer method. 
      #
      # Returns JSON object.
      #  
      # Raises BlueviaError when serializing failed.
      #
      
      def serialize(entity) 
        begin
          message = entity.to_json
          encoding = {"Content-Type" => "application/json"}
          return {:body => message.to_s, :encoding=> encoding}
        rescue
          e = Bluevia::Schemas::BVResponse.new
          e.code = Bluevia::BVEXCEPTS[Bluevia::ERR_SER]
          e.message = Bluevia::ERR_SER
          raise Bluevia::BlueviaError.new(e)
        end
      end
    end #class JSON_serializer
    
    #
    # This class implements RPC serializer under JSON
    #
    
    class JsonRpcSerializer < JsonSerializer
      
      #
      # Serializer method for RPC. To create RPC envelop with methodCall, id and version 
      # and calls serialize method from JSON Serializer.
      # 
      # Returns a JSON object with information  
      #
      # Raises BlueviaError when serializing failed
      #
      
      def serialize(entity_params) 
        begin
          entity_params[:id] = rand(11111).to_s
          entity_params[:version]= "v1"
                  
          entity=  {:methodCall=> entity_params}
                  
          message = super(entity)
          encoding = {"Content-Type" => "application/json"}
          return {:body => message[:body].to_s, :encoding=> encoding}
           
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