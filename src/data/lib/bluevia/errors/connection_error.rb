#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  #
  # This class defines ConnectionError and attributes of this object
  # to_s for ConnectionError is also implemented that returns code and message information
  #
  class ConnectionError < StandardError
    attr_accessor :code, :message, :additional_data

    def initialize (params)
      @code = params.code
      @message = params.message
      @additional_data = params.additional_data
   
    end

    def to_s
      return "Error #{@code.to_s} received: #{@message.to_s}"
    end
  end
end