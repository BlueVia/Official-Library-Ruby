#require 'xsd/qname'

module Schemas; module Mms_types


# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}MessageType
#   address - Schemas::Mms_types::UserIdType
#   receiptRequest - Schemas::Mms_types::SimpleReferenceType
#   senderName - SOAP::SOAPString
#   originAddress - Schemas::Mms_types::UserIdType
#   subject - SOAP::SOAPString
#   priority - (any)
class MessageType
  attr_accessor :address
  attr_accessor :receiptRequest
  attr_accessor :senderName
  attr_accessor :originAddress
  attr_accessor :subject
  attr_accessor :priority

  def initialize(address = [], receiptRequest = nil, senderName = nil, originAddress = nil, subject = nil, priority = nil)
    @address = address
    @receiptRequest = receiptRequest
    @senderName = senderName
    @originAddress = originAddress
    @subject = subject
    @priority = priority
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}MessageDeliveryStatusType
class MessageDeliveryStatusType < ::Array
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}DeliveryInformationType
#   address - Schemas::Mms_types::UserIdType
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

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}ReceivedMessagesType
class ReceivedMessagesType < ::Array
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}MessageReferenceType
#   messageIdentifier - SOAP::SOAPString
#   destinationAddress - Schemas::Mms_types::UserIdType
#   originAddress - Schemas::Mms_types::UserIdType
#   subject - SOAP::SOAPString
#   priority - (any)
#   message - SOAP::SOAPString
#   dateTime - SOAP::SOAPDateTime
class MessageReferenceType
  attr_accessor :messageIdentifier
  attr_accessor :destinationAddress
  attr_accessor :originAddress
  attr_accessor :subject
  attr_accessor :priority
  attr_accessor :message
  attr_accessor :dateTime

  def initialize(messageIdentifier = nil, destinationAddress = nil, originAddress = nil, subject = nil, priority = nil, message = nil, dateTime = nil)
    @messageIdentifier = messageIdentifier
    @destinationAddress = destinationAddress
    @originAddress = originAddress
    @subject = subject
    @priority = priority
    @message = message
    @dateTime = dateTime
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}MessageURIType
#   bodyText - SOAP::SOAPString
#   fileReferences - SOAP::SOAPString
class MessageURIType
  attr_accessor :bodyText
  attr_accessor :fileReferences

  def initialize(bodyText = nil, fileReferences = [])
    @bodyText = bodyText
    @fileReferences = fileReferences
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}DeliveryStatusUpdateType
#   correlator - SOAP::SOAPString
#   deliveryStatus - Schemas::Mms_types::DeliveryInformationType
class DeliveryStatusUpdateType
  attr_accessor :correlator
  attr_accessor :deliveryStatus

  def initialize(correlator = nil, deliveryStatus = nil)
    @correlator = correlator
    @deliveryStatus = deliveryStatus
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}DeliveryReceiptNotificationType
#   reference - Schemas::Mms_types::SimpleReferenceType
#   originAddress - Schemas::Mms_types::UserIdType
#   filterCriteria - SOAP::SOAPString
class DeliveryReceiptNotificationType
  attr_accessor :reference
  attr_accessor :originAddress
  attr_accessor :filterCriteria

  def initialize(reference = nil, originAddress = [], filterCriteria = nil)
    @reference = reference
    @originAddress = originAddress
    @filterCriteria = filterCriteria
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}ReceivedMessageAsyncType
#   correlator - SOAP::SOAPString
#   message - Schemas::Mms_types::MessageReferenceType
class ReceivedMessageAsyncType
  attr_accessor :correlator
  attr_accessor :message

  def initialize(correlator = nil, message = nil)
    @correlator = correlator
    @message = message
  end
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}MessageNotificationType
#   reference - Schemas::Mms_types::SimpleReferenceType
#   destinationAddress - Schemas::Mms_types::UserIdType
#   criteria - SOAP::SOAPString
class MessageNotificationType
  attr_accessor :reference
  attr_accessor :destinationAddress
  attr_accessor :criteria

  def initialize(reference = nil, destinationAddress = [], criteria = nil)
    @reference = reference
    @destinationAddress = destinationAddress
    @criteria = criteria
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
#   ipAddress - Schemas::Mms_types::IpAddressType
#   m_alias - (any)
#   otherId - Schemas::Mms_types::OtherIdType
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

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}MessagePriorityType
class MessagePriorityType < ::String
  Default = MessagePriorityType.new("Default")
  High = MessagePriorityType.new("High")
  Low = MessagePriorityType.new("Low")
  Normal = MessagePriorityType.new("Normal")
end

# {http://www.telefonica.com/schemas/UNICA/REST/mms/v1/}DeliveryStatusType
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
