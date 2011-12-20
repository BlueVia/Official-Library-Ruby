#require 'xsd/qname'

module Schemas; module Common_types


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
#   ipAddress - Schemas::Common_types::IpAddressType
#   m_alias - (any)
#   otherId - Schemas::Common_types::OtherIdType
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
