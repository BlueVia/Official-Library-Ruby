#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/schemas/sch_advertising'
require 'bluevia/clients/commons/bv_base_client'

module Bluevia
  

  class BVAdvertisingClient < BVBaseClient

    
  private  
    
    #
    # This method complete common features for trusted and untrusted advertising API
    #
    # required params :
    # [*ad_space*]          Adspace of the Bluevia application
    #
    # optional params :
    # [*country*]           Country where the target user is located. 
    #                       Must follow ISO-3166 (see http://www.iso.org/iso/country_codes.htm).
    # [*phone_number*]      Phone number to whom the Ad is targeted (just for trusted partners)
    # [*target_user_id*]    Identifier of the Target User
    # [*ad_request_id*]     An unique id for the request. 
    #                       If it is not set, the SDK will generate it automatically
    # [*ad_presentation*]   Value is a code that represents ad's format type
    #                       Bluevia::Schemas::TypeId::IMAGE (TEXT also available)
    # [*keywords*]          Array with keywords the ads are related to, separated by comas
    # [*protection_policy*] Adult control policy. It will be safe, low, high. 
    #                       It should be checked with the application SLA in the gSDP.
    #                       Bluevia::Schemas::ProtectionPolicy::LOW (HIGH and SAFE also allowed)
    # [*user_agent*]        User agent of the client
    #
    # returns a Bluevia::Schemas::SimpleAdResponse object that contains the ad meta-data
    # raise BlueviaError
    #
    
    def get_advertising_2l(ad_space, country= nil, phone_number = nil, target_user_id = nil, ad_request_id = nil, ad_presentation = nil, keywords = nil, protection_policy = nil, user_agent = nil)
      # Calls auxiliary method to complete common parts for both advertising methods
      params = get_adv(ad_space, country, ad_request_id, ad_presentation, keywords, protection_policy, user_agent, target_user_id)
      
      headers = get_headers(phone_number)
      
      begin
        resp = base_create("/simple/requests", nil, params, headers)
        return filter_response(resp)
      rescue BlueviaError => ie 
        unless @Ir.additional_data.nil?
          error_parsed = @err_parser.parse(@Ir.additional_data[:body])
          @Ir.message = parse_error(error_parsed)
        
          raise BlueviaError.new(@Ir)
        else
          raise BlueviaError.new(ie)
        end
        
      end

    end
    
    #
    # This method is needed only for trusted API to include extra headers  
    #
    
    def get_headers(identity)
      extra_h = nil
      unless identity.nil?
        extra_h = {"X-PhoneNumber" => identity}
      end
      return extra_h
      
    end
    
    #
    # This method allows to filter server response and returns a SimpleAdResponse
    # object (see Schemas::SimpleAdResponse for more information)
    #
    # Raises BlueviaError when a problem was detected and SimpleAdResponse wasn't created.
    #
    
    def filter_response(response)
      
      return SimpleAdResponse.new if response.nil? or !response.instance_of?(Hash)
      
      adv = SimpleAdResponse.new
      adv_list = Array.new
      
      begin
        resources = response[:adResponse][:ad][:resource][:creative_element]
        adv.request_id = response[:adResponse][:attributes][:id]
          
        if resources.instance_of?(Array)
          resources.each{|resource|
            adv.advertising_list << assign_item(resource)
             
          }
          
        else
          adv.advertising_list << assign_item(resources)
          
        end
        
        return adv
        
      rescue StandardError => error
        e = BVResponse.new
        e.code = COD_12
        e.message = ERR_PART3 + "create SimpleAdResponse."
        raise BlueviaError.new(e)
      end
    
    end
    
    #
    # This method complete every CreativeElement of advertising_list 
    #
    def assign_item(resource)
      item = CreativeElement.new
      item.type   = resource[:attributes][:type]
      item.value       = resource[:attribute].instance_of?(Array) ? resource[:attribute][1] : resource[:attribute]
      item.interaction = resource[:interaction][:attribute]

      return item
    end
    
    #
    # This method checks every mandatory parameters, complete the optional ones
    # and prepares params Hash for advertising serializer
    #
    
    def get_adv(ad_space, country = nil, ad_request_id = nil, ad_presentation = nil, keywords = nil, protection_policy = nil, user_agent = nil, target_user_id = nil)
      
      Utils.check_attribute(ad_space, ERR_PART1 + " 'ad_space' " + ERR_PART2)
      token_key = @Ic.get_token
      
      params = Hash.new
      params[:ad_space] = ad_space
      
      # This generates an ad_request_id if it's passed empty
      if ad_request_id.nil? or ad_request_id.eql? ""
        ad_space = String.new(ad_space)
        ad_request_id = ((ad_space.length > 10) ? ad_space[0,9] : ad_space)
        ad_request_id << Time.now.strftime("%Y%m%d%H:%M:%S")
        unless token_key.nil?
          ad_request_id << ((token_key.length > 10) ? token_key[0,9] : token_key)
        end
        params[:ad_request_id] = ad_request_id
      else
        params[:ad_request_id] = ad_request_id
      end
      
      unless ad_presentation.nil?
        params[:ad_presentation] = ad_presentation
      end
      
      # Keywords is a word Array. Here is concatenated by '|' as required 
      # in Bluevia specifications
      unless keywords.nil?
        if keywords.instance_of? Array
          keywords = keywords.join('|')
        end
        params[:keywords] = keywords
      end
      
      unless protection_policy.nil?
        params[:protection_policy] = protection_policy
      end
      
      unless user_agent.nil?
        params[:user_agent] = user_agent
      else
        params[:user_agent] = "none"
      end
      
      unless target_user_id.nil?
        params[:target_user_id] = target_user_id
      end
      
      unless country.nil?
        params[:country] = country
      end
      
      return params
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
    # This method sets parser and serializer for Advertising client
    # It also complete Rest part of the URL
    #
    def init
      
      @Is = Bluevia::ISerializer::UrlEncodedSerializer.new
      @Ip = Bluevia::IParser::XmlParser.new
      @err_parser = Bluevia::IParser::JsonParser.new
      is_rest
      
    end
  end
end