#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


require 'bluevia/clients/commons/bv_base_client'
require 'bluevia/schemas/sch_messaging'

module Bluevia
  

  class BVMtClient < BVBaseClient
  
  private
    
    #
    # Checks for 3-legged mandatory parameters
    #
    
    def init_untrusted (mode, consumerKey, consumerSecret, tokenKey, tokenSecret)
      Utils.check_attribute tokenKey, ERR_PART1 + " 'tokenKey' " + ERR_PART2
      Utils.check_attribute tokenSecret, ERR_PART1 + " 'tokenSecret' " + ERR_PART2
      
      super
      
    end
    
    #
    # Super send method that implements common parts for send methods (both trusted or untrusted ones)
    # 'origin_address' and 'sender_name' are related to trusted partners
    #
    # Returns BlueviaError when only endpoint or only correlator are provided
    # (when provided, both of them must appear)
    #
    
    def send (destination, origin_address, sender_name, endpoint, correlator)
      # Checks for common parameters
      Utils.check_attribute destination, ERR_PART1 + " 'destination' " + ERR_PART2
      
      # If not origin_address provided (untrusted) then origin_address is created as an alias
      if origin_address.nil?  
        origin = @Ic.get_token
        orig = {:alias => origin}
      else
        orig = {"phoneNumber" => origin_address}
      end
      
      dest_phones = Array.new      

      # Set destination phones
  
      if destination.instance_of?(Array)
        destination.each { |i|
          dest_phones << {:phoneNumber=> i}
        }
      else
        dest_phones << {:phoneNumber=> destination}
      end
      
      unless sender_name.nil? 
        aux_iliar = {:address=> dest_phones, 
             :originAddress=> orig,
             :senderName => sender_name}
      else
        aux_iliar = {:address=> dest_phones, 
             :originAddress=> orig}
      end
         
      if  endpoint.nil? and correlator.nil?
        return aux_iliar
      elsif not endpoint.nil? and not correlator.nil?
        simple_reference = {:endpoint=>endpoint, :correlator =>correlator}
        aux_iliar[:receiptRequest] = simple_reference
        return aux_iliar
      else
        e = BVResponse.new
        e.code = BVEXCEPTS[ERR_MS1]
        e.message = ERR_MS1
        raise BlueviaError.new(e)
      end  
      
    end
    
    #
    # Super method for get_delivery_status ones that completes common parts
    #
    def get_delivery_status (message_id)
      
      Utils.check_attribute message_id, ERR_PART1 + " 'message_id' " + ERR_PART2
      
      response = base_retrieve(MS_OUT + "/#{message_id}/deliverystatus", nil)
      
    end
    
    #
    # Filters location header for send methods
    #
    def filter_send 
      response = @Ir.additional_data
      
      if response[:headers].has_key? 'location'
          
          location = response[:headers]['location']
          return location.gsub(/^.+\/requests\/([^\/]+)\/deliverystatus/, '\1')
          
        else
          e = BVResponse.new
          e.code = BVEXCEPTS[ERR_MS5]
          e.message = ERR_MS5
          raise BlueviaError.new(e)
        end
    end
    
    #
    # Auxiliary method to fill extra trusted headers
    #
    def get_headers(identity)
      extra_h = nil
      unless identity.nil?
        extra_h = {"X-ChargedId" => identity}
      end
      return extra_h
    end
  end
end
