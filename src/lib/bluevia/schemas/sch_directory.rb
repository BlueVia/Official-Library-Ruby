#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  module Schemas
    #
    # DirectoryDataSets object for Directory Client. 
    # Is required for requesting user information. Define four blocks of information: 
    # [* USER_PROFILE *]
    # [* USER_ACCESS_INFO *] 
    # [* USER_TERMINAL_INFO *] 
    # [* USER_PERSONAL_INFO *]
    #
    class DirectoryDataSets
      VALID_METHODS = %W(Profile AccessInfo TerminalInfo PersonalInfo).freeze
      
      USER_PROFILE        = VALID_METHODS[0]
      USER_ACCESS_INFO    = VALID_METHODS[1]
      USER_TERMINAL_INFO  = VALID_METHODS[2]
      USER_PERSONAL_INFO  = VALID_METHODS[3]
      
    end
    
    #
    # UserInfo object for Directory Client. 
    # Is returned from get_user_info method. 
    # Contains four objects with information about four specific blocks of information available  
    #
    class UserInfo
      attr_accessor :profile, :personal_info, :access_info, :terminal_info
      
      def initialize (profile = nil, personal_info = nil, access_info = nil, terminal_info = nil)
        @profile = profile
        @personal_info = personal_info
        @access_info = access_info
        @terminal_info = terminal_info
      end
    end
    
    #
    # AccessFields object for Directory Client. 
    # Is required for requesting user access information. 
    # Define valid fields for get_access_info method 
    # [* ACCESS_TYPE *]
    # [* APN *]
    # [* ROAMING *] 
    #
    class AccessFields
      VALID_FIELDS = %W(accessType apn roaming).freeze
      ACCESS_TYPE = VALID_FIELDS[0]
      APN = VALID_FIELDS[1]
      ROAMING = VALID_FIELDS[2]
    end
    
    #
    # AccessInfo object for Directory Client. 
    # Is returned from get_access_info method. 
    #
    class AccessInfo 
      attr_accessor :access_type, :apn, :roaming
      
      def initialize (access_type = nil, apn = nil, roaming = nil)
        @access_type = access_type
        @apn = apn
        @roaming = roaming
      end
    end
      
    #
    # PersonalFields object for Directory Client. 
    # Is required for requesting user personal information. 
    # Define valid fields for get_personal_info method 
    # [* GENDER *] (only one valid field)
    #
    class PersonalFields
      VALID_FIELDS = %w(gender).freeze
      GENDER = VALID_FIELDS[0]
    end
    
    #
    # PersonalInfo object for Directory Client. 
    # Is returned from get_personal_info method. 
    #
    class PersonalInfo 
      attr_accessor :gender
       
      def initialize(gender = nil)
        @gender = gender
      end
    end
   
    #
    # TerminalFields object for Directory Client. 
    # Is required for requesting user terminal information. 
    # Define valid fields for get_terminal_info method 
    # [* BRAND *]
    # [* MODEL *] 
    # [* VERSION *] 
    # [* MMS *] 
    # [* EMS *] 
    # [* SMART_MESSAGING *] 
    # [* WAP *] 
    # [* US_SD_PHASE *] 
    # [* EMS_MAX_NUMBER *]
    # [* WAP_PUSH *] 
    # [* MMS_VIDEO *] 
    # [* VIDEO_STREAMING *] 
    # [* SCREEN_RESOLUTION *] 
    #
    class TerminalFields
      VALID_FIELDS = %w(brand model version mms ems smartMessaging wap ussdPhase emsMaxNumber wapPush mmsVideo videoStreaming screenResolution).freeze
      
      BRAND = VALID_FIELDS[0]
      MODEL = VALID_FIELDS[1]
      VERSION = VALID_FIELDS[2]
      MMS = VALID_FIELDS[3]
      EMS = VALID_FIELDS[4]
      SMART_MESSAGING = VALID_FIELDS[5]
      WAP = VALID_FIELDS[6]
      US_SD_PHASE = VALID_FIELDS[7]
      EMS_MAX_NUMBER = VALID_FIELDS[8]
      WAP_PUSH = VALID_FIELDS[9]
      MMS_VIDEO = VALID_FIELDS[10]
      VIDEO_STREAMING = VALID_FIELDS[11]
      SCREEN_RESOLUTION = VALID_FIELDS[12]
    end
    
    #
    # TerminalInfo object for Directory Client. 
    # Is returned from get_terminal_info method. 
    #
    class TerminalInfo 
      attr_accessor :brand, :model, :version, :mms, :ems, :smart_messaging, :wap, :us_sd_phase, :ems_max_number, :wap_push, :mms_video, :video_streaming, :screen_resolution
      
      def initialize(brand = nil, model = nil, version = nil, mms = nil, ems = nil, smart_messaging = nil, wap = nil, us_sd_phase = nil, ems_max_number = nil, wap_push = nil, mms_video = nil, video_streaming = nil, screen_resolution = nil)
        @brand = brand
        @model = model
        @version = version
        @mms = mms
        @ems = ems
        @smart_messaging = smart_messaging
        @wap = wap
        @us_sd_phase = us_sd_phase
        @ems_max_number = ems_max_number
        @wap_push = wap_push
        @mms_video = mms_video
        @video_streaming = video_streaming
        @screen_resolution = screen_resolution
        
      end
    
    end
    
    #
    # ProfileFields object for Directory Client. 
    # Is required for requesting user profile information. 
    # Define valid fields for get_profile_info method 
    # [* USER_TYPE *]
    # [* ICB *] 
    # [* OCB *] 
    # [* LANGUAGE *] 
    # [* PARENTAL_CONTROL *] 
    # [* OPERATOR_ID *] 
    # [* MMS_STATUS *] 
    # [* SEGMENT *] 
    #
    class ProfileFields
      VALID_FIELDS = %w(userType icb ocb language parentalControl operatorId mmsStatus segment).freeze
      
      USER_TYPE = VALID_FIELDS[0]
      ICB = VALID_FIELDS[1]
      OCB = VALID_FIELDS[2]
      LANGUAGE = VALID_FIELDS[3]
      PARENTAL_CONTROL = VALID_FIELDS[4]
      OPERATOR_ID = VALID_FIELDS[5]
      MMS_STATUS = VALID_FIELDS[6]
      SEGMENT = VALID_FIELDS[7]
    end
    
    #
    # Profile object for Directory Client. 
    # Is returned from get_profile_info method. 
    #
    class Profile
      
      attr_accessor :user_type, :icb, :ocb, :language, :parental_control, :operator_id, :mms_status, :segment
      
      def initialize(user_type = nil, icb = nil, ocb = nil, language = nil, parental_control = nil, operator_id = nil, mms_status = nil, segment = nil)
        @user_type = user_type
        @icb = icb
        @ocb = ocb
        @language = language
        @parental_control = parental_control
        @operator_id = operator_id
        @mms_status = mms_status
        @segment = segment
      end
    end
  end
end