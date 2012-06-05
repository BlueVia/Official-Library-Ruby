#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

require 'bluevia/clients/bv_directory_client'

module Bluevia
  
  #
  # Bluevia Directory API is a set of functions which allows users to retrieve 
  # user-related information, divided in four blocks (user profile, access information, 
  # personal information and terminal information). 
  # 
  # This class fetches information related to Directory API. 
  #

  class BVDirectory < BVDirectoryClient

    #
    # To create BVDirectory client (only for 3 legged clients)
    # required params :
    # [*mode*]            Communication mechanism to communicate with the gSDP
    #                     BVMode::LIVE (also SANDBOX and TEST available)
    # [*consumer_key*]    Oauth consumer key supplied by the developer.
    # [*consumer_secret*] Oauth consumer secret supplied by the developer.
    # [*token_key*]       Oauth access token key returned by the get_access_token call.
    # [*token_secret*]    Oauth access token secret returned by the get_access_token call.
    #
    # example:
    #   @bc = BVDirectory.new(Bluevia::BVMode::LIVE,"XXXXX", "YYYYY", "WWWWWWWWWWWWWW", "ZZZZZZZZZZZZZ") 
    #

    def initialize(mode, consumer_key, consumer_secret, token_key, token_secret)

      init_untrusted(mode, consumer_key, consumer_secret, token_key, token_secret)
      
      if mode.eql? SANDBOX
        is_sandbox("/" + BP_DIR)
      else 
        @base_uri = @base_uri + "/" + BP_DIR
      end
      
    end
    
    #
    # This method allows an application to get all the user context information. 
    # Applications will only be able to retrieve directory information on themselves.
    # Information blocks can be filtered using the data set
    #
    # optional params :
    # [*data_set*]          'data_set' must be nil (to get all posible information) 
    #                       or an array with length bigger than one.
    #                       DirectoryDataSets class is provided to help user with possible 
    #                       values for this parameter
    #                       ex: [Bluevia::Schemas::DirectoryDataSets::USER_ACCESS_INFO,
    #                       Bluevia::Schemas::DirectoryDataSets::USER_PROFILE]
    #
    # returns a Bluevia::Schemas::UserInfo object that contains four objects with different
    # information required (PersonalInfo, Profile, TerminalInfo and AccessInfo) 
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_user_info 
    #   response = @bc.get_user_info([Bluevia::Schemas::DirectoryDataSets::USER_ACCESS_INFO,
    #                                 Bluevia::Schemas::DirectoryDataSets::USER_PROFILE])
    #
    
    def get_user_info(data_set = nil)
      super(nil,data_set)
    end
    
    #
    # This method retrieves User Access Information from directory. 
    # Applications will only be able to retrieve directory information on themselves.
    #
    # optional params :
    # [*fields*]          'fields' must be nil (to get all posible information) or an array
    #                     AccessFields class is provided to help user with possible
    #                     values for this parameter
    #                     ex: [Bluevia::Schemas::AccessFields::ACCESS_TYPE]
    #
    # returns a Bluevia::Schemas::AccessInfo object that contains information required
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_access_info 
    #   response = @bc.get_access_info([Bluevia::Schemas::AccessFields::ACCESS_TYPE])
    #   
    
    def get_access_info(fields = nil)
      super(nil, fields)
    end
    
    #
    # This method retrieves User Personal Information from directory. 
    # Applications will only be able to retrieve directory information on themselves.
    #
    # optional params :
    # [*fields*]          'fields' must be nil (to get all posible information) or an array
    #                     PersonalFields class is provided to help user with possible
    #                     values for this parameter
    #                     ex: [Bluevia::Schemas::PersonalFields::GENDER]
    #
    # returns a Bluevia::Schemas::PersonalInfo object that contains information required
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_personal_info 
    #   response = @bc.get_personal_info([Bluevia::Schemas::PersonalFields::GENDER])
    #   
    
    def get_personal_info(fields = nil)
      super(nil, fields)
    end
    
    #
    # This method retrieves User Terminal Information from directory. 
    # Applications will only be able to retrieve directory information on themselves.
    #
    # optional params :
    # [*fields*]          'fields' must be nil (to get all posible information) or an array
    #                     TerminalFields class is provided to help user with possible
    #                     values for this parameter
    #                     ex: [TerminalFields::SCREEN_RESOLUTION]
    #
    # returns a Bluevia::Schemas::TerminalInfo object that contains information required
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_terminal_info 
    #   response = @bc.get_terminal_info([TerminalFields::SCREEN_RESOLUTION,
    #                                     TerminalFields::EMS])
    # 
    
    def get_terminal_info(fields = nil)
      super(nil, fields)
    end
    
    #
    # This method retrieves User Profile Information from directory. 
    # Applications will only be able to retrieve directory information on themselves.
    #
    # optional params :
    # [*fields*]          'fields' must be nil (to get all posible information) or an array
    #                     ProfileFields class is provided to help user with possible
    #                     values for this parameter
    #                     ex: [ProfileFields::PARENTAL_CONTROL, ProfileFields::ICB]
    #
    # returns a Bluevia::Schemas::Profile object that contains information required
    # raise BlueviaError
    #
    # example:
    #   response = @bc.get_profile_info 
    #   response = @bc.get_profile_info([ProfileFields::PARENTAL_CONTROL, ProfileFields::ICB])
    # 
    
    def get_profile_info(fields = nil)
      super(nil, fields)
    end
  end
end
