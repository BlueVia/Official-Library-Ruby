#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

module Bluevia
  #
  # Inner class that wraps the response
  #

  class Response
    # HTTP response code
    attr_accessor :code
    # HTTP response body
    attr_accessor :body
    # HTTP headers (required when creating resources)
    attr_accessor :headers

    attr_accessor :message

    def initialize
      @body = ""
    end

    def to_s
      value = String.new
      self.instance_variables.each{ |var|
        value << "#{var} : #{get_value(self.instance_variable_get(var))} \n"
      }
      value
    end

    def get_value(var)
      if var.instance_of?(String)
        var
      elsif var.instance_of?(Hash)
        var.to_a.join(" - ")
      else
        var
      end
    end

    def [](value)
      return self.instance_variable_get("@#{value}")
    end

  end
end
