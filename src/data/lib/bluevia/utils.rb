#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'net/http'
require 'bluevia/schemas'

module Bluevia
  #
  # Helper to enable internal features
  #

  module Utils


    include Bluevia::Schemas
    
    #
    # Check if an attribute is not null
    # Raise an exception in case of attribute.nil?
    #
    def Utils.check_attribute(attribute, message)
      
      e = BVResponse.new
      e.code = COD_1
      e.message = message
      
      if attribute.nil?
        raise BlueviaError.new e
      elsif attribute.instance_of?(String)
        if attribute.empty?
          raise BlueviaError.new e 
        end
      else
        if attribute.respond_to?(:size)
          if attribute.size == 0
            raise BlueviaError.new e 
          end
        end
      end
    end
    
    #
    # Check if an params include key 
    # Raise an exception if key is not included
    #
    def Utils.check_params(params, key, message)
      e = BVResponse.new
      e.code = COD_1
      e.message = message
      
      if params.instance_of? Hash
        if params[:"#{key}"].nil?
          raise BlueviaError.new e 
        else
          return true
        end
      else
        raise BlueviaError.new e 
      end
    end
    
    #
    # Check if attribute is a number 
    # Raise an exception if not
    #
    def Utils.check_number(attribute, message)
      e = BVResponse.new
      e.code = COD_1
      e.message = message
    
      if attribute.to_i!=0
        return true
      else
        raise BlueviaError.new(e)
      end
      
    end
    
    #
    # Filter headers
    #
    def Utils.filter_header (response, key)
  
        if response.additional_data[:headers].has_key? key
          return response.additional_data[:headers][key]
        else
          return nil
        end
    end
      
  end
end