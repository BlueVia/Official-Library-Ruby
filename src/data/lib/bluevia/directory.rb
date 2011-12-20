#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'json'
require 'net/http'
require 'bluevia/base_client'

module Bluevia
  #
  # This class is in charge of access Bluevia Directory API
  #

  class Directory < BaseClient

    # Valid methods included in the API
    @@valid_methods = %W[Profile AccessInfo TerminalInfo]
    USER_PROFILE        = @@valid_methods[0]
    USER_ACCESS_INFO    = @@valid_methods[1]
    USER_TERMINAL_INFO  = @@valid_methods[2]

    # Base Path for Directory API
    BASEPATH_API = "/Directory"

    def initialize(params = nil)
      super(params)
    end

    #
    # This method is in charge of retrieving user information
    # [*user*] User identifier, a valid access token
    # [*type*] information to be retrieved. Can be one or more @@valid_methods.
    # Raises RuntimeError if any error occurred while invoking the request
    #

    def get_user_info(type = nil)
      #Utils.check_attribute user, "User cannot be null"
      user = @token
      unless type.nil?
        if (type.instance_of?(Array))
          if type.length == 1
            if @@valid_methods.to_a.include?(type[0])
              _type = "/" + type[0]
            else
              raise SyntaxError, "Type not allowed. #{@@valid_methods} only."
            end
          else
            _type = ""
            data_sets = type.join(',')
          end

        elsif (type.instance_of?(String))
          if @@valid_methods.to_a.include?(type)
            _type = "/User" + type
          else
            raise SyntaxError, "Type not allowed. #{@@valid_methods} only."
          end
        else
          raise SyntaxError, "Invalid type"
        end
      else
        _type = ""
      end

      # Include the alias prefix in URL
      identifier = CGI::escape("alias:#{user}")

      params = Hash.new

      unless data_sets.nil?
        params[:dataSets] = data_sets
      end

      # returns the response body
      GET("#{get_basepath}/#{identifier}/UserInfo#{_type}", params, nil)
    end

      
  end
end

