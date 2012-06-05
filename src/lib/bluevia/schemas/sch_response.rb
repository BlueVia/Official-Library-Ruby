#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module Schemas
  
  #
  # BVResponse object for request responses
  # attributes:
  # [*code*] response code 
  # [*message*] response message
  # [*additional_data*] usually a hash with headers and body
  #
 
  class BVResponse
    attr_accessor :code
    attr_accessor :message
    attr_accessor :additional_data
 
    def initialize
     @code = nil
     @message = nil
     @additional_data = nil
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
  
  # 
  # UserIdType object (not in use now but probably needed in the future) 
  #
  class UserIdType
    attr_accessor :type
    attr_accessor :value
    
    VALID_TYPES = %W(phoneNumber anyUri ipAddress otherId alias).freeze
    PHONE_NUMBER = VALID_TYPES[0]
    ANY_URI = VALID_TYPES[1]
    IP_ADDRESS = VALID_TYPES[2]
    OTHER_ID = VALID_TYPES[3]
    ALIAS = VALID_TYPES[4]
    
    def initialize(type = nil, value = nil)
      @type = type
      @value = value
    end
  end
  end
end
