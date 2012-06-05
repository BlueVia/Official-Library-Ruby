#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#


require 'bluevia/clients/commons/bv_base_client'
require 'bluevia/schemas/sch_messaging'

module Bluevia

  class BVMoClient < BVBaseClient

    private
    
    #
    # Auxiliary method to complete common part of get_x_messagex methods
    #
    
    def get_messages(registration_id, message_id = nil, attachment_id=nil, params=nil)
      
      # Checks for common mandatory parameter
      Utils.check_attribute registration_id, ERR_PART1 + " 'registration_id' " + ERR_PART2
      
      # Fills URL depending on optional parameters
      unless message_id.nil?
         message_id = "/#{message_id}"
      else
         message_id = ""  
      end
      unless attachment_id.nil?
        attachment_id = "/attachments/" + attachment_id.to_s
      else
        attachment_id =""
      end
      
      response = base_retrieve(MS_IN+"/#{registration_id}/messages#{message_id}#{attachment_id}", params)
      
    end

    #
    # Super method for start_notification ones that implements commons part
    #
    
    def start_notification(destination, endpoint, criteria, correlator)
      # Checks for mandatory parameters
      Utils.check_attribute destination, ERR_PART1 + " 'destination' " + ERR_PART2
      Utils.check_attribute endpoint, ERR_PART1 + " 'endpoint' " + ERR_PART2
      Utils.check_attribute endpoint, ERR_PART1 + " 'criteria' " + ERR_PART2
      
      # Creates correlator if not provided
      if correlator.nil?
        correlator = rand(11111).to_s
      end
      
      # Creates common part of the parameter's hash
      simple_reference = {:endpoint=>endpoint, :correlator =>correlator}
      message = {:reference => simple_reference, 
             :destinationAddress => {:phoneNumber => destination},
             :criteria => criteria}

      return message
      
    end
    
    #
    # Super method for stop_notification ones that implements commons part
    #  
    
    def stop_notification(subscription_id)

      # Checks for mandatory parameters
      Utils.check_attribute subscription_id, ERR_PART1 + " 'subscription_id' " + ERR_PART2
 
      response = base_delete(MS_IN + MS_SUBS + "/#{subscription_id}", nil) 
      if response.additional_data[:body].nil? and response.code.eql?'204'
        return true
      else
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "stop message notification."
        raise BlueviaError.new(e)
      end
        
    end
    
    #
    # Auxiliary method that check if response contains a phoneNumber or alias
    #
    
    def get_phone_alias(s_hash, key)
      if s_hash[key].instance_of? Hash
        if s_hash[key].has_key? 'phoneNumber'
            ret = s_hash[key]['phoneNumber'] 
        elsif s_hash[key].has_key? 'alias'
            ret = s_hash[key]['alias']
        end
      elsif s_hash[key].instance_of? Array
        s_hash[key].each{|add|
          if add.has_key? 'phoneNumber'
            ret = add['phoneNumber'] 
          elsif add.has_key? 'alias'
            ret = add['alias']
          end
          }
      else
        ret = nil
      end
        
      return ret
    end
  end
end
