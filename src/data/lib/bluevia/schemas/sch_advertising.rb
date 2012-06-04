#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module Schemas
   
    #
    # SimpleAdResponse object for Advertising Client
    # attributes:
    # [*request_id*] Id of the requested advertising 
    # [*advertising_list*] Array full of CreativeElements
    #
    class SimpleAdResponse
      attr_accessor :request_id, :advertising_list
      
      def initialize(request_id = nil, advertising_list = [])
        @request_id = request_id
        @advertising_list = advertising_list
        
      end
    end
    
    #
    # CreativeElement object for Advertising Client
    # attributes:
    # [*type*] Type of the advertisement retrieved
    # [*value*] Url or text of the advertisement
    # [*interaction*] Corresponding URL for a 'click2wap' interaction
    #     
    class CreativeElement
      attr_accessor :type, :value, :interaction
      
      def initialize(type =nil, value = nil, interaction = nil)
        @type = type
        @value = value
        @interaction = interaction
      end
    
    end

    #
    # TypeId object for Advertising Client. 
    # Is required for requesting advertisings. Define only two valid methods for 
    # an advertisement: Image or Text
    #    
    class TypeId
        @valid_methods = %W(0101 0104).freeze
      
      IMAGE   = @valid_methods[0]
      TEXT    = @valid_methods[1]
    end
    
    #
    # ProtectionPolicy object for Advertising Client. 
    # Is required for requesting advertisings. Define three levels for this parameter 
    # LOW, SAFE OR HIGH level proteccion
    #
    class ProtectionPolicy
      LOW = "1"
      SAFE = "2"
      HIGH = "3"
    end
  

  end
end