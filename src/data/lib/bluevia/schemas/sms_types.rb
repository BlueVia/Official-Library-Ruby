#require 'xsd/qname'

module Schemas; module Sms_types


# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}SMSTextType
#   address - Schemas::Sms_types::UserIdType
#   message - SOAP::SOAPString
#   receiptRequest - Schemas::Sms_types::SimpleReferenceType
#   originAddress - Schemas::Sms_types::UserIdType
#   encode - SOAP::SOAPString
#   sourceport - SOAP::SOAPInt
#   destinationport - SOAP::SOAPInt
#   esm_class - SOAP::SOAPInt
#   data_coding - SOAP::SOAPInt
class SMSTextType
  attr_accessor :address
  attr_accessor :message
  attr_accessor :receiptRequest
  attr_accessor :originAddress
  attr_accessor :encode
  attr_accessor :sourceport
  attr_accessor :destinationport
  attr_accessor :esm_class
  attr_accessor :data_coding

  def initialize(address = [], message = nil, receiptRequest = nil, originAddress = nil, encode = nil, sourceport = nil, destinationport = nil, esm_class = nil, data_coding = nil)
    @address = address
    @message = message
    @receiptRequest = receiptRequest
    @originAddress = originAddress
    @encode = encode
    @sourceport = sourceport
    @destinationport = destinationport
    @esm_class = esm_class
    @data_coding = data_coding
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}SMSDeliveryStatusType
class SMSDeliveryStatusType < ::Array
end

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}SMSDeliveryStatusUpdateType
#   correlator - SOAP::SOAPString
#   deliveryStatus - Schemas::Sms_types::DeliveryInformationType
class SMSDeliveryStatusUpdateType
  attr_accessor :correlator
  attr_accessor :deliveryStatus

  def initialize(correlator = nil, deliveryStatus = nil)
    @correlator = correlator
    @deliveryStatus = deliveryStatus
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}ReceivedSMSType
class ReceivedSMSType < ::Array
end

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}ReceivedSMSAsyncType
#   correlator - SOAP::SOAPString
#   message - Schemas::Sms_types::SMSMessageType
class ReceivedSMSAsyncType
  attr_accessor :correlator
  attr_accessor :message

  def initialize(correlator = nil, message = nil)
    @correlator = correlator
    @message = message
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}SMSNotificationType
#   reference - Schemas::Sms_types::SimpleReferenceType
#   destinationAddress - Schemas::Sms_types::UserIdType
#   criteria - SOAP::SOAPString
class SMSNotificationType
  attr_accessor :reference
  attr_accessor :destinationAddress
  attr_accessor :criteria

  def initialize(reference = nil, destinationAddress = [], criteria = nil)
    @reference = reference
    @destinationAddress = destinationAddress
    @criteria = criteria
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}DeliveryInformationType
#   address - Schemas::Sms_types::UserIdType
#   deliveryStatus - (any)
#   description - SOAP::SOAPString
class DeliveryInformationType
  attr_accessor :address
  attr_accessor :deliveryStatus
  attr_accessor :description

  def initialize(address = nil, deliveryStatus = nil, description = nil)
    @address = address
    @deliveryStatus = deliveryStatus
    @description = description
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}SMSMessageType
#   message - SOAP::SOAPString
#   originAddress - Schemas::Sms_types::UserIdType
#   destinationAddress - Schemas::Sms_types::UserIdType
#   dateTime - SOAP::SOAPDateTime
class SMSMessageType
  attr_accessor :message
  attr_accessor :originAddress
  attr_accessor :destinationAddress
  attr_accessor :dateTime

  def initialize(message = nil, originAddress = nil, destinationAddress = nil, dateTime = nil)
    @message = message
    @originAddress = originAddress
    @destinationAddress = destinationAddress
    @dateTime = dateTime
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
#   ipAddress - Schemas::Sms_types::IpAddressType
#   m_alias - (any)
#   otherId - Schemas::Sms_types::OtherIdType
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

# {http://www.telefonica.com/schemas/UNICA/REST/sms/v1/}DeliveryStatusType
class DeliveryStatusType < ::String
  DeliveredToNetwork = DeliveryStatusType.new("DeliveredToNetwork")
  DeliveredToTerminal = DeliveryStatusType.new("DeliveredToTerminal")
  DeliveryImpossible = DeliveryStatusType.new("DeliveryImpossible")
  DeliveryNotificationNotSupported = DeliveryStatusType.new("DeliveryNotificationNotSupported")
  DeliveryUncertain = DeliveryStatusType.new("DeliveryUncertain")
  MessageWaiting = DeliveryStatusType.new("MessageWaiting")
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
