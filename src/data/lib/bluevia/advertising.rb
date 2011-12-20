require 'bluevia/ad_response'

#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

module Bluevia
  #
  # This class fetches information related to Advertising API.
  #

  class Advertising < BaseClient

    # optional parameters in the request
    OPTIONAL_PARAMS = [:ad_presentation, :ad_presentation_size, :keywords, :protection_policy, :country, :ad_request_id]

    # required parameters in the request
    REQUIRED_PARAMS = [:user_agent, :ad_space]

    VALID_PARAMS = OPTIONAL_PARAMS + REQUIRED_PARAMS

    def initialize(params = nil)
      super(params)
    end

    # Base Path for Advertising API
    BASEPATH_API = "/Advertising"

    #
    # This method fetchs an Ad from the server.
    # [*params*] Hash object that must include at least the REQUIRED_PARAMS and
    # cero or more OPTIONAL_PARAMS
    # i.e.
    # 
    # response = @service.request(
    #      {:user_agent => "Mozilla 5.0",
    #       :ad_request_id => "a1x4zasg58",
    #       :ad_space => "1200",
    #       :keywords => "bar"
    #      })
    #
    def request(params)
      # This generates an ad_request_id if it's passed empty
      if params[:ad_request_id].nil? or params[:ad_request_id] == ""
	adspace = String.new(params[:ad_space])
	adrequestid = ((adspace.length > 10) ? adspace[0,9] : adspace)
	adrequestid << Time.now.strftime("%Y%m%d%H:%M:%S")
	unless @token.nil?
	  adrequestid << ((@token.length > 10) ? @token[0,9] : @token)
	end
	params[:ad_request_id] = adrequestid
      end
      Utils.check_attribute(params, "params cannot be null")
      
      REQUIRED_PARAMS.each { |param|
        Utils.check_attribute(params[param], "#{param} cannot be null")
      }

      # if two-legged, country is required
      if is_two_legged
        Utils.check_attribute(
          params[:country],
          "An ISO-3166 country is required in two legged authorization"
        )
      end

      # delete any parameter that is neither optional nor mandatory
      params.delete_if{|key,value| VALID_PARAMS.index(key).nil?}

      # include in the request all the parameters
     
      message = params.collect{|k,v| "#{k}=#{CGI::escape(v.to_s)}"}.join('&')
     
      # this should be sent without content-Type because fails to validate signature
      path = set_path("#{get_basepath}/simple/requests")
      path = include_params(path, DEFAULT_PARAMS)
      puts path
      response = authorized_client.post(
        path,
          message,
        {'Accept' => 'application/json', 'content-type' => 'application/x-www-form-urlencoded'})

      resp = handle_response(create_response(response)).body
      
      filter_response(resp)      
    end

    private

    def filter_response(response)
      if response.nil? or !response.instance_of?(Hash)
        p "empty!!"
      end
            
      return AdResponse.new if response.nil? or !response.instance_of?(Hash)

      result = AdResponse.new
      #begin
        
        id = response[:adResponse][:ad][:resource][:attributes][:ad_presentation]
        resources = response[:adResponse][:ad][:resource][:creative_element]
        item = Hash.new
        if resources.instance_of?(Array)
          resources.each{|resource|
            result << assign_item(resource, id)
          }
        else
          result << assign_item(resources, id)
        end
      #rescue

      #end
      result
    end

    def assign_item(resource, id)
          item = Hash.new
          item["type_id"]     = id
          item["type_name"]   = resource[:attributes][:type]
          item["value"]       = resource[:attribute].instance_of?(Array) ? resource[:attribute][1] : resource[:attribute]
          item["interaction"] = resource[:interaction][:attribute]

      item
    end

  end
end