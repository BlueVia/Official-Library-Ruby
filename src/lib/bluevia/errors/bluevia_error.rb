#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  #
  # This class defines BlueviaError and attributes of this object
  # to_s for BlueviaError is also implemented that returns code and message information
  #
  class BlueviaError < StandardError
    attr_accessor :code, :message 
    
    def initialize (params)
      @code = params.code
      @message = params.message
    
    end

    def to_s
      "Error #{@code.to_s} received: #{@message.to_s}"
    end
  end
end