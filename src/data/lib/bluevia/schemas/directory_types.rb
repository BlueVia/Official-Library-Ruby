#require 'xsd/qname'

module Schemas; module Directory_types


# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}UserInfoType
#   userIdentities - Schemas::Directory_types::UserIdentitiesType
#   userPersonalInfo - Schemas::Directory_types::UserPersonalInfoType
#   userProfile - Schemas::Directory_types::UserProfileType
#   userAccessInfo - Schemas::Directory_types::UserAccessInfoType
#   userTerminalInfo - Schemas::Directory_types::UserTerminalInfoType
class UserInfoType
  attr_accessor :userIdentities
  attr_accessor :userPersonalInfo
  attr_accessor :userProfile
  attr_accessor :userAccessInfo
  attr_accessor :userTerminalInfo

  def initialize(userIdentities = nil, userPersonalInfo = nil, userProfile = nil, userAccessInfo = nil, userTerminalInfo = nil)
    @userIdentities = userIdentities
    @userPersonalInfo = userPersonalInfo
    @userProfile = userProfile
    @userAccessInfo = userAccessInfo
    @userTerminalInfo = userTerminalInfo
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}UserIdentitiesType
#   phoneNumber - (any)
#   telUri - (any)
#   sipUri - (any)
#   email - (any)
#   ipAddress - Schemas::Directory_types::IpAddressType
#   m_alias - (any)
#   otherId - Schemas::Directory_types::OtherIdType
class UserIdentitiesType
  attr_accessor :phoneNumber
  attr_accessor :telUri
  attr_accessor :sipUri
  attr_accessor :email
  attr_accessor :ipAddress
  attr_accessor :otherId

  def m_alias
    @v_alias
  end

  def m_alias=(value)
    @v_alias = value
  end

  def initialize(phoneNumber = nil, telUri = nil, sipUri = nil, email = nil, ipAddress = nil, v_alias = nil, otherId = nil)
    @phoneNumber = phoneNumber
    @telUri = telUri
    @sipUri = sipUri
    @email = email
    @ipAddress = ipAddress
    @v_alias = v_alias
    @otherId = otherId
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}UserPersonalInfoType
#   displayName - SOAP::SOAPString
#   name - Schemas::Directory_types::NameType
#   namePrefix - SOAP::SOAPString
#   nameSufix - SOAP::SOAPString
#   birthday - SOAP::SOAPDate
#   gender - Schemas::Directory_types::GenderType
#   address - Schemas::Directory_types::AddressType
#   lastUpdated - (any)
#   extension - Schemas::Directory_types::ExtensionType
class UserPersonalInfoType
  attr_accessor :displayName
  attr_accessor :name
  attr_accessor :namePrefix
  attr_accessor :nameSufix
  attr_accessor :birthday
  attr_accessor :gender
  attr_accessor :address
  attr_accessor :lastUpdated
  attr_accessor :extension
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(displayName = nil, name = nil, namePrefix = nil, nameSufix = nil, birthday = nil, gender = nil, address = nil, lastUpdated = nil, extension = nil)
    @displayName = displayName
    @name = name
    @namePrefix = namePrefix
    @nameSufix = nameSufix
    @birthday = birthday
    @gender = gender
    @address = address
    @lastUpdated = lastUpdated
    @extension = extension
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}UserProfileType
#   userType - (any)
#   imsi - (any)
#   icb - (any)
#   ocb - (any)
#   language - (any)
#   simType - (any)
#   parentalControl - (any)
#   creditControl - Schemas::Directory_types::FlagType
#   diversionMsisdn - (any)
#   enterpriseName - (any)
#   roaming - Schemas::Directory_types::FlagType
#   operatorId - (any)
#   mmsStatus - Schemas::Directory_types::MmsStatusType
#   segment - (any)
#   subsegment - (any)
#   subscribedService - Schemas::Directory_types::SubscribedServiceType
#   lastUpdated - (any)
#   extension - Schemas::Directory_types::ExtensionType
class UserProfileType
  attr_accessor :userType
  attr_accessor :imsi
  attr_accessor :icb
  attr_accessor :ocb
  attr_accessor :language
  attr_accessor :simType
  attr_accessor :parentalControl
  attr_accessor :creditControl
  attr_accessor :diversionMsisdn
  attr_accessor :enterpriseName
  attr_accessor :roaming
  attr_accessor :operatorId
  attr_accessor :mmsStatus
  attr_accessor :segment
  attr_accessor :subsegment
  attr_accessor :subscribedService
  attr_accessor :lastUpdated
  attr_accessor :extension
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(userType = nil, imsi = nil, icb = nil, ocb = nil, language = nil, simType = nil, parentalControl = nil, creditControl = nil, diversionMsisdn = nil, enterpriseName = nil, roaming = nil, operatorId = nil, mmsStatus = nil, segment = nil, subsegment = nil, subscribedService = [], lastUpdated = nil, extension = nil)
    @userType = userType
    @imsi = imsi
    @icb = icb
    @ocb = ocb
    @language = language
    @simType = simType
    @parentalControl = parentalControl
    @creditControl = creditControl
    @diversionMsisdn = diversionMsisdn
    @enterpriseName = enterpriseName
    @roaming = roaming
    @operatorId = operatorId
    @mmsStatus = mmsStatus
    @segment = segment
    @subsegment = subsegment
    @subscribedService = subscribedService
    @lastUpdated = lastUpdated
    @extension = extension
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}UserAccessInfoType
#   connected - Schemas::Directory_types::FlagType
#   ipAddress - Schemas::Directory_types::IpAddressType
#   accessType - SOAP::SOAPString
#   connectionTime - SOAP::SOAPUnsignedInt
#   apn - SOAP::SOAPString
#   roaming - Schemas::Directory_types::FlagType
#   extension - Schemas::Directory_types::ExtensionType
class UserAccessInfoType
  attr_accessor :connected
  attr_accessor :ipAddress
  attr_accessor :accessType
  attr_accessor :connectionTime
  attr_accessor :apn
  attr_accessor :roaming
  attr_accessor :extension
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(connected = nil, ipAddress = nil, accessType = nil, connectionTime = nil, apn = nil, roaming = nil, extension = nil)
    @connected = connected
    @ipAddress = ipAddress
    @accessType = accessType
    @connectionTime = connectionTime
    @apn = apn
    @roaming = roaming
    @extension = extension
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}UserTerminalInfoType
#   brand - SOAP::SOAPString
#   model - SOAP::SOAPString
#   version - SOAP::SOAPString
#   screenResolution - SOAP::SOAPString
#   imei - (any)
#   mms - Schemas::Directory_types::FlagType
#   ems - Schemas::Directory_types::FlagType
#   smartMessaging - Schemas::Directory_types::FlagType
#   wap - Schemas::Directory_types::FlagType
#   ussdPhase - SOAP::SOAPString
#   syncMl - Schemas::Directory_types::FlagType
#   syncMlVersion - SOAP::SOAPString
#   emsMaxNumber - SOAP::SOAPString
#   email - Schemas::Directory_types::FlagType
#   emn - Schemas::Directory_types::FlagType
#   adc_OTA - Schemas::Directory_types::FlagType
#   status - Schemas::Directory_types::StatusType
#   lastUpdated - (any)
#   extension - Schemas::Directory_types::ExtensionType
class UserTerminalInfoType
  attr_accessor :brand
  attr_accessor :model
  attr_accessor :version
  attr_accessor :screenResolution
  attr_accessor :imei
  attr_accessor :mms
  attr_accessor :ems
  attr_accessor :smartMessaging
  attr_accessor :wap
  attr_accessor :ussdPhase
  attr_accessor :syncMl
  attr_accessor :syncMlVersion
  attr_accessor :emsMaxNumber
  attr_accessor :email
  attr_accessor :emn
  attr_accessor :adc_OTA
  attr_accessor :status
  attr_accessor :lastUpdated
  attr_accessor :extension
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(brand = nil, model = nil, version = nil, screenResolution = nil, imei = nil, mms = nil, ems = nil, smartMessaging = nil, wap = nil, ussdPhase = nil, syncMl = nil, syncMlVersion = nil, emsMaxNumber = nil, email = nil, emn = nil, adc_OTA = nil, status = nil, lastUpdated = nil, extension = nil)
    @brand = brand
    @model = model
    @version = version
    @screenResolution = screenResolution
    @imei = imei
    @mms = mms
    @ems = ems
    @smartMessaging = smartMessaging
    @wap = wap
    @ussdPhase = ussdPhase
    @syncMl = syncMl
    @syncMlVersion = syncMlVersion
    @emsMaxNumber = emsMaxNumber
    @email = email
    @emn = emn
    @adc_OTA = adc_OTA
    @status = status
    @lastUpdated = lastUpdated
    @extension = extension
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}NameType
#   firstName - SOAP::SOAPString
#   lastName - SOAP::SOAPString
#   middleName - SOAP::SOAPString
class NameType
  attr_accessor :firstName
  attr_accessor :lastName
  attr_accessor :middleName

  def initialize(firstName = nil, lastName = nil, middleName = nil)
    @firstName = firstName
    @lastName = lastName
    @middleName = middleName
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}SubscribedServiceType
#   xmlattr_name - SOAP::SOAPString
class SubscribedServiceType
  AttrName = XSD::QName.new(nil, "name")

  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def __xmlattr
    @__xmlattr ||= {}
  end

  def xmlattr_name
    __xmlattr[AttrName]
  end

  def xmlattr_name=(value)
    __xmlattr[AttrName] = value
  end

  def initialize
    @__xmlele_any = nil
    @__xmlattr = {}
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}AddressType
#   street - SOAP::SOAPString
#   streetNumber - SOAP::SOAPUnsignedInt
#   locality - SOAP::SOAPString
#   region - SOAP::SOAPString
#   postalCode - SOAP::SOAPUnsignedInt
#   country - SOAP::SOAPString
#   ext - SOAP::SOAPString
class AddressType
  attr_accessor :street
  attr_accessor :streetNumber
  attr_accessor :locality
  attr_accessor :region
  attr_accessor :postalCode
  attr_accessor :country
  attr_accessor :ext

  def initialize(street = nil, streetNumber = nil, locality = nil, region = nil, postalCode = nil, country = nil, ext = nil)
    @street = street
    @streetNumber = streetNumber
    @locality = locality
    @region = region
    @postalCode = postalCode
    @country = country
    @ext = ext
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}UserIdType
#   phoneNumber - (any)
#   anyUri - SOAP::SOAPAnyURI
#   ipAddress - Schemas::Directory_types::IpAddressType
#   m_alias - (any)
#   otherId - Schemas::Directory_types::OtherIdType
class UserIdType
  attr_accessor :phoneNumber
  attr_accessor :anyUri
  attr_accessor :ipAddress
  attr_accessor :otherId

  def m_alias
    @v_alias
  end

  def m_alias=(value)
    @v_alias = value
  end

  def initialize(phoneNumber = nil, anyUri = nil, ipAddress = nil, v_alias = nil, otherId = nil)
    @phoneNumber = phoneNumber
    @anyUri = anyUri
    @ipAddress = ipAddress
    @v_alias = v_alias
    @otherId = otherId
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}IpAddressType
#   ipv4 - (any)
#   ipv6 - (any)
class IpAddressType
  attr_accessor :ipv4
  attr_accessor :ipv6

  def initialize(ipv4 = nil, ipv6 = nil)
    @ipv4 = ipv4
    @ipv6 = ipv6
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}OtherIdType
#   type - SOAP::SOAPString
#   value - SOAP::SOAPString
class OtherIdType
  attr_accessor :type
  attr_accessor :value

  def initialize(type = nil, value = nil)
    @type = type
    @value = value
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}ClientExceptionType
#   exceptionCategory - SOAP::SOAPString
#   exceptionId - SOAP::SOAPInt
#   text - SOAP::SOAPString
#   variables - SOAP::SOAPString
class ClientExceptionType
  attr_accessor :exceptionCategory
  attr_accessor :exceptionId
  attr_accessor :text
  attr_accessor :variables

  def initialize(exceptionCategory = nil, exceptionId = nil, text = nil, variables = [])
    @exceptionCategory = exceptionCategory
    @exceptionId = exceptionId
    @text = text
    @variables = variables
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}ServerExceptionType
#   exceptionCategory - SOAP::SOAPString
#   exceptionId - SOAP::SOAPInt
#   text - SOAP::SOAPString
#   variables - SOAP::SOAPString
class ServerExceptionType
  attr_accessor :exceptionCategory
  attr_accessor :exceptionId
  attr_accessor :text
  attr_accessor :variables

  def initialize(exceptionCategory = nil, exceptionId = nil, text = nil, variables = [])
    @exceptionCategory = exceptionCategory
    @exceptionId = exceptionId
    @text = text
    @variables = variables
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}SimpleReferenceType
#   endpoint - SOAP::SOAPAnyURI
#   correlator - SOAP::SOAPString
class SimpleReferenceType
  attr_accessor :endpoint
  attr_accessor :correlator

  def initialize(endpoint = nil, correlator = nil)
    @endpoint = endpoint
    @correlator = correlator
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}ExtensionType
class ExtensionType
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}StatusType
class StatusType < ::String
  Approved = StatusType.new("approved")
  NotApproved = StatusType.new("not approved")
end

# {http://www.telefonica.com/schemas/UNICA/REST/directory/v1/}MmsStatusType
class MmsStatusType < ::String
  Activated = MmsStatusType.new("activated")
  Deactivated = MmsStatusType.new("deactivated")
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}FlagType
class FlagType < ::String
  No = FlagType.new("no")
  Yes = FlagType.new("yes")
end

# {http://www.telefonica.com/schemas/UNICA/REST/common/v1}GenderType
class GenderType < ::String
  Female = GenderType.new("female")
  Male = GenderType.new("male")
end


end; end
