#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

%w[rubygems json uri net/http].each{|x| require "#{x}"}
%w[bluevia_logger directory sms mms oauth oauth_payment payment advertising location].each{|api|  require "bluevia/#{api}"}

module Bluevia
  #
  # This class is the main client to access Bluevia API.
  # It defines a services factory that provides an isolated way to reach
  # each API. Currently the following APIs are supported:
  # * oAuth authentication
  # * SMS
  # * MMS
  # * Advertising
  # * Directory
  #
  # When creating a BlueviaClient instance, basic authentication parameters
  # can be provided:
  #
  # require 'bluevia'
  #
  # bc = BlueviaClient.new(
  #      { :consumer_key => <YOUR_CONSUMER_KEY>,
  #        :consumer_secret => <YOUR_CONSUMER_SECRET>,
  #        :token => <OAUTH_TOKEN>,
  #        :token_secret => <OAUTH_TOKEN_SECRET>
  #      })
  #

  class BlueviaClient
    include BlueviaLogger

    # Constructor
    def initialize(params = nil)

      unless params.nil? || params[:uri].nil?
        rest = BaseClient.create_rest_client(params[:uri])
      else
        rest = BaseClient.create_rest_client
      end

      @commercial      = false
      @consumer_key    = nil
      @consumer_secret = nil

      unless params.nil?
        %w(consumer_key consumer_secret token token_secret).each{ |param|
          self.instance_variable_set(:"@#{param}", params[:"#{param}"]) unless params[:"#{param}"].nil?
        }
      end
      
      @factory = ServicesFactory.new(rest)
    end

    # Retrieves a specific service to call any related API
    # i.e.
    # sms = bc.get_service(:Sms)
    def get_service(_service)
      service = @factory.get(_service)
      service[:consumer_key]    = @consumer_key   unless @consumer_key.nil?
      service[:consumer_secret] = @consumer_secret unless @consumer_secret.nil?
      service[:token]           = @token          unless @token.nil?
      service[:token_secret]    = @token_secret   unless @token_secret.nil?
      service[:commercial]      = @commercial
      return service
    end

    # Client will get access to commercial APIs
    def set_commercial
      @commercial = true
    end

    # Client will get access to sandbox APIs
    def set_sandbox
      @commercial = false
    end

    # {true|false} if commercial or sandbox client
    def commercial?
      return @commercial
    end
  end

  # This service factory wraps the initialization of a service
  class ServicesFactory
    include BlueviaLogger
    def initialize(rest = nil)
      @directory      = Directory.new({:rest =>rest, :logger => logger})
      @sms            = Sms.new({:rest =>rest, :logger => logger})
      @mms            = Mms.new({:rest =>rest, :logger => logger})
      @advertising    = Advertising.new({:rest =>rest, :logger => logger})
      @oauth          = Oauth.new({:rest =>rest, :logger => logger})
      @oauth_payment = OauthPayment.new({:rest =>rest, :logger => logger})
      @location       = Location.new({:rest =>rest, :logger => logger})
      @payment        = Payment.new({:rest =>rest, :logger => logger})
    end

    def get(service)
      case service.to_s.downcase
        when "directory"
          return @directory
        when "sms"
          return @sms
        when "mms"
          return @mms
        when "oauth"
          return @oauth
        when "oauth_payment"
          return @oauth_payment
        when "advertising"
          return @advertising
        when "location"
          return @location
        when "payment"
          return @payment
        else
          raise(SyntaxError, "Service not valid")
      end
    end

  end
end
