#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/schemas/sch_directory'
require 'bluevia/clients/commons/bv_base_client'

module Bluevia


  class BVDirectoryClient < BVBaseClient

  private
  
    #
    # This method complete common features for trusted and untrusted directory API
    # related to get_user_info method.
    # Returns UserInfo object (for more information check Schemas::UserInfo)
    #
  
    def get_user_info(phone_number = nil, data_set = nil)
      
      _ds = DirectoryDataSets.new
  
      # Checks dataset in order to be nil or bigger than one element array
      unless data_set.nil?
        if (data_set.instance_of?(Array))
          if data_set.length == 1
            e = BVResponse.new
            e.code = COD_1
            e.message = "'data_set' must be nil or an array with length bigger than one."
            raise BlueviaError.new(e)
          else
            data_set.each{|data|
              # Checks if dataset parameter is a valid value 
              check_dataset(data, _ds)
            }
            data_sets = data_set.join(',')
          end
        else
        
          e = BVResponse.new
          e.code = COD_1
          e.message = "'data_set' must be nil or an array with length bigger than one."
          raise BlueviaError.new(e)
        end
      else
        data_sets = nil
      end
      
      # Include the alias/phoneNumber prefix in URL
      identifier = get_identifier(phone_number)
      
      params = Hash.new

      unless data_sets.nil?
        params[:dataSets] = data_sets
      end
     
      response = base_retrieve("/#{identifier}/UserInfo", params)
      return filter_full(response)
    end
    
    #
    # This method complete common features for trusted and untrusted directory API
    # related to get_access_info method.
    # Returns AccessInfo object (for more information check Schemas::AccessInfo)
    #    

    def get_access_info(phone_number = nil, fields = nil)
      
      _pi = AccessFields.new
      final_obj = AccessInfo.new
      
      _fields = create_fields(fields, _pi)
      
      # Include the alias/phoneNumber prefix in URL
      identifier = get_identifier(phone_number)

      params = Hash.new

      unless fields.nil?
        params[:fields] = "'#{_fields}'"
      end
      
      response = base_retrieve("/#{identifier}/UserInfo/UserAccessInfo", params)
      return filter_response(response['userAccessInfo'], final_obj)
    end
  
    #
    # This method complete common features for trusted and untrusted directory API
    # related to get_personal_info method.
    # Returns PersonalInfo object (for more information check Schemas::PersonalInfo)
    #        
    
    def get_personal_info(phone_number = nil, fields = nil)
      user = @Ic.get_token
      _pi = PersonalFields.new
      final_obj = PersonalInfo.new
      
      _fields = create_fields(fields, _pi)
      
      # Include the alias/phoneNumber prefix in URL
      identifier = get_identifier(phone_number)

      params = Hash.new

      unless fields.nil?
        params[:fields] = "'#{_fields}'"
      end
      
      response = base_retrieve("/#{identifier}/UserInfo/UserPersonalInfo", params)
      return filter_response(response['userPersonalInfo'], final_obj)
      
    end

    #
    # This method complete common features for trusted and untrusted directory API
    # related to get_terminal_info method.
    # Returns TerminalInfo object (for more information check Schemas::TerminalInfo)
    #    
    
    def get_terminal_info(phone_number = nil, fields = nil)
      
      _pi = TerminalFields.new
      final_obj = TerminalInfo.new
      
      _fields = create_fields(fields, _pi)
      
      # Include the alias/phoneNumber prefix in URL
      identifier = get_identifier(phone_number)

      params = Hash.new

      unless fields.nil?
        params[:fields] = "'#{_fields}'"
      end
      
      response = base_retrieve("/#{identifier}/UserInfo/UserTerminalInfo", params)
      return filter_response(response['userTerminalInfo'], final_obj)
    end
  
    #
    # This method complete common features for trusted and untrusted directory API
    # related to get_profile_info method.
    # Returns Profile object (for more information check Schemas::Profile)
    # 
    
    def get_profile_info(phone_number = nil, fields = nil)
      user = @Ic.get_token
      _pi = ProfileFields.new
      final_obj = Profile.new
      
      _fields = create_fields(fields, _pi)
      
      # Include the alias/phoneNumber prefix in URL
      identifier = get_identifier(phone_number)

      params = Hash.new

      unless fields.nil?
        params[:fields] = "'#{_fields}'"
      end
      
      response = base_retrieve("/#{identifier}/UserInfo/UserProfile", params)
      return filter_response(response['userProfile'], final_obj)
    end
  
    #
    # Verifies fields validity and prepare them to be included in the request
    # Raise BlueviaError if 'fields' includes an invalid field
    #
    
    def create_fields(fields, _pi)
      unless fields.nil?
        if (fields.instance_of?(Array))
          fields.each{|field|
            check_field(field, _pi)
            }
          _fields = fields.join(',')
            
        elsif (fields.instance_of?(String))
          check_field(fields, _pi)
            _fields = fields
          
        else
          e = BVResponse.new
          e.code = COD_1
          e.message = "Field type not allowed."
          raise BlueviaError.new(e)
        end
      end
      return _fields
    end

    #
    # Verifies data_set validity and prepare them to be included in the request
    # Raise BlueviaError if 'data_set' includes an invalid dataset (not included between DirectoryDataSets)
    #    
    
    def check_dataset(data_set, _ds)
      e = BVResponse.new
      e.code = COD_1
      if !DirectoryDataSets::VALID_METHODS.include?(data_set)
        e.message = "'#{data_set}' method not allowed. #{DirectoryDataSets::VALID_METHODS.to_s} methods only"
        raise BlueviaError.new(e)
      end
      
    end
    
    #
    # Verifies if field belongs to obj's class valid fields
    #
    def check_field(field, obj)
      e = BVResponse.new
      e.code = COD_1
      
      if !obj.class::VALID_FIELDS.include?(field)
        e.message = "'#{field}' field not allowed. #{obj.class::VALID_FIELDS.to_s} fields only."
        raise BlueviaError.new(e)
      end
      
    end
    
    #
    # Filters response parameter and fill obj (were object can be
    # PersonalInfo, Profile, TerminalInfo or AccessInfo)
    #
    
    def filter_response(response, obj)
      return  obj if response.nil? or !response.instance_of?(Hash)
      
      begin
        obj = assign(response, obj)
        
      rescue StandardError => serror
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + " create directory object info."
        raise BlueviaError.new(e)
      end
      
    end
    
    #
    # Filter response and fill UserInfo
    #
    def filter_full(response)
      return UserInfo.new if response.nil? or !response.instance_of?(Hash)
      
      full = UserInfo.new
      partial_pi = PersonalInfo.new
      partial_p = Profile.new
      partial_ti = TerminalInfo.new
      partial_ai = AccessInfo.new
      
      begin
        response = response['userInfo']
        if response.has_key? 'userPersonalInfo'
          partial_pi = filter_response(response['userPersonalInfo'], partial_pi)
        else
          partial_pi =nil
        end
        if response.has_key? 'userProfile'
          partial_p = filter_response(response['userProfile'], partial_p)
        else
          partial_p = nil
        end
        if response.has_key? 'userAccessInfo'
          partial_ai = filter_response(response['userAccessInfo'], partial_ai)
        else
          partial_ai = nil
        end
        if response.has_key? 'userTerminalInfo'
          partial_ti = filter_response(response['userTerminalInfo'], partial_ti)
        else
          partial_ti = nil
        end
        
        full.personal_info = partial_pi
        full.access_info = partial_ai
        full.profile = partial_p
        full.terminal_info = partial_ti
        
        return full
        
      rescue StandardError => error
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + " create UserInfo."
        raise BlueviaError.new(e)
      end
        
    end
    
    #
    # Assign every element of response to obj
    #
    
    def assign(response, obj)
      response.each{|k,v|
        obj.instance_variables.each{|attr|
          if "#{attr}".eql? "@#{k}"
            obj.instance_variable_set(:"@#{k}", v)
          end
          }
        }

      return obj
    end
    
    #
    # When phone_number is provided (trusted), phoneNumber is filled
    # if not (untrusted) then alias is created 
    #
    
    def get_identifier(phone_number)
      
      if phone_number.nil?
        identifier = CGI::escape("alias:#{@Ic.get_token}")
      else
        identifier = CGI::escape("phoneNumber:#{phone_number}")
      end
      return identifier
    end

  
    def init_untrusted(mode, consumer_key, consumer_secret, token_key, token_secret)
      
      super
      init
      
    end
    
    def init_trusted(mode, consumer_key, consumer_secret, cert_file, cert_pass)
      
      super
      init
      
    end
    
    #
    # This method sets parser and serializer for Directory client
    # It also complete Rest part of the URL
    #
    
    def init
      @Is = Bluevia::ISerializer::JsonSerializer.new
      @Ip = Bluevia::IParser::JsonParser.new
      
      is_rest

    end
      
  end
end

