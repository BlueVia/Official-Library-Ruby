#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'json'
require 'net/http'
require 'bluevia/base_client'
require 'bluevia/schemas/location_types'

module Bluevia
  #
  # This class is in charge of access Bluevia Location API
  #

  class Location < BaseClient
    include Schemas::Location_types    

    # Base Path for Location API
    BASEPATH_API = "/Location"

    def initialize(params = nil)
      super(params)
    end

    # The Application invokes getLocation to Retrieve the ‘TerminalLocation’ or
    # TerminalLocationforGroup
    #
    # [*acc_accuracy* Accuracy that is acceptable for a response
    #
    def get_location( acc_accuracy = nil )
      params = Hash.new
      unless acc_accuracy.nil?
        params["acceptableAccuracy"] = acc_accuracy
      end
      params["locatedParty"] = "alias:#{@token}"
      GET("#{get_basepath}/TerminalLocation", params)
    end
  end
end

