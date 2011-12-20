#require 'xsd/qname'

module Schemas; module Payment_types


# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}PaymentParamsType
#   timestamp - SOAP::SOAPDateTime
#   paymentInfo - Schemas::Payment_types::PaymentInfoType
#   receiptRequest - Schemas::Payment_types::SimpleReferenceType
class PaymentParamsType
  attr_accessor :timestamp
  attr_accessor :paymentInfo
  attr_accessor :receiptRequest

  def initialize(timestamp = nil, paymentInfo = nil, receiptRequest = nil)
    @timestamp = timestamp
    @paymentInfo = paymentInfo
    @receiptRequest = receiptRequest
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}PaymentResultType
#   transactionId - SOAP::SOAPString
#   transactionStatus - (any)
#   transactionStatusDescription - SOAP::SOAPString
class PaymentResultType
  attr_accessor :transactionId
  attr_accessor :transactionStatus
  attr_accessor :transactionStatusDescription
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(transactionId = nil, transactionStatus = nil, transactionStatusDescription = nil)
    @transactionId = transactionId
    @transactionStatus = transactionStatus
    @transactionStatusDescription = transactionStatusDescription
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}GetPaymentStatusParamsType
#   transactionId - SOAP::SOAPString
class GetPaymentStatusParamsType
  attr_accessor :transactionId

  def initialize(transactionId = nil)
    @transactionId = transactionId
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}GetPaymentStatusResultType
#   transactionStatus - (any)
#   transactionStatusDescription - SOAP::SOAPString
class GetPaymentStatusResultType
  attr_accessor :transactionStatus
  attr_accessor :transactionStatusDescription
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(transactionStatus = nil, transactionStatusDescription = nil)
    @transactionStatus = transactionStatus
    @transactionStatusDescription = transactionStatusDescription
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}NotifyPaymentFinalStatusParamsType
#   transactionId - SOAP::SOAPString
#   transactionStatus - (any)
#   transactionStatusDescription - SOAP::SOAPString
class NotifyPaymentFinalStatusParamsType
  attr_accessor :transactionId
  attr_accessor :transactionStatus
  attr_accessor :transactionStatusDescription
  attr_reader :__xmlele_any

  def set_any(elements)
    @__xmlele_any = elements
  end

  def initialize(transactionId = nil, transactionStatus = nil, transactionStatusDescription = nil)
    @transactionId = transactionId
    @transactionStatus = transactionStatus
    @transactionStatusDescription = transactionStatusDescription
    @__xmlele_any = nil
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}PaymentInfoType
#   amount - SOAP::SOAPUnsignedInt
#   currency - SOAP::SOAPString
class PaymentInfoType
  attr_accessor :amount
  attr_accessor :currency

  def initialize(amount = nil, currency = nil)
    @amount = amount
    @currency = currency
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/common/v1}UserIdType
#   phoneNumber - (any)
#   anyUri - (any)
#   ipAddress - Schemas::Payment_types::IpAddressType
#   m_alias - (any)
#   otherId - Schemas::Payment_types::OtherIdType
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

# {http://www.telefonica.com/schemas/UNICA/RPC/common/v1}IpAddressType
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

# {http://www.telefonica.com/schemas/UNICA/RPC/common/v1}OtherIdType
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

# {http://www.telefonica.com/schemas/UNICA/RPC/common/v1}SimpleReferenceType
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

# {http://www.telefonica.com/schemas/UNICA/RPC/definition/v1}MethodCallType
#   id - SOAP::SOAPString
#   version - SOAP::SOAPString
class MethodCallType
  attr_accessor :id
  attr_accessor :version

  def initialize(id = nil, version = nil)
    @id = id
    @version = version
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}MethodCallType
#   id - SOAP::SOAPString
#   version - SOAP::SOAPString
#   method - Schemas::Payment_types::MethodType
#   params - Schemas::Payment_types::MethodCallType_::Params
class MethodCallType_ < MethodCallType

  # inner class for member: params
  # {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}params
  #   paymentParams - Schemas::Payment_types::PaymentParamsType
  #   getPaymentStatusParams - Schemas::Payment_types::GetPaymentStatusParamsType
  #   notifyPaymentFinalStatusParams - Schemas::Payment_types::NotifyPaymentFinalStatusParamsType
  class Params
    attr_accessor :paymentParams
    attr_accessor :getPaymentStatusParams
    attr_accessor :notifyPaymentFinalStatusParams

    def initialize(paymentParams = nil, getPaymentStatusParams = nil, notifyPaymentFinalStatusParams = nil)
      @paymentParams = paymentParams
      @getPaymentStatusParams = getPaymentStatusParams
      @notifyPaymentFinalStatusParams = notifyPaymentFinalStatusParams
    end
  end

  attr_accessor :id
  attr_accessor :version
  attr_accessor :method
  attr_accessor :params

  def initialize(id = nil, version = nil, method = nil, params = nil)
    @id = id
    @version = version
    @method = method
    @params = params
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/definition/v1}MethodResponseType
#   id - SOAP::SOAPString
#   version - SOAP::SOAPString
#   error - Schemas::Payment_types::ErrorType
class MethodResponseType
  attr_accessor :id
  attr_accessor :version
  attr_accessor :error

  def initialize(id = nil, version = nil, error = nil)
    @id = id
    @version = version
    @error = error
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}MethodResponseType
#   id - SOAP::SOAPString
#   version - SOAP::SOAPString
#   error - Schemas::Payment_types::ErrorType
#   result - Schemas::Payment_types::MethodResponseType_::Result
class MethodResponseType_ < MethodResponseType

  # inner class for member: result
  # {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}result
  #   paymentResult - Schemas::Payment_types::PaymentResultType
  #   getPaymentStatusResult - Schemas::Payment_types::GetPaymentStatusResultType
  class Result
    attr_accessor :paymentResult
    attr_accessor :getPaymentStatusResult

    def initialize(paymentResult = nil, getPaymentStatusResult = nil)
      @paymentResult = paymentResult
      @getPaymentStatusResult = getPaymentStatusResult
    end
  end

  attr_accessor :id
  attr_accessor :version
  attr_accessor :error
  attr_accessor :result

  def initialize(id = nil, version = nil, error = nil, result = nil)
    @id = id
    @version = version
    @error = error
    @result = result
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/definition/v1}ErrorType
#   code - SOAP::SOAPString
#   message - SOAP::SOAPString
#   data - SOAP::SOAPString
class ErrorType
  attr_accessor :code
  attr_accessor :message
  attr_accessor :data

  def initialize(code = nil, message = nil, data = [])
    @code = code
    @message = message
    @data = data
  end
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}MethodType
class MethodType < ::String
  CANCEL_AUTHORIZATION = MethodType.new("CANCEL_AUTHORIZATION")
  GET_PAYMENT_STATUS = MethodType.new("GET_PAYMENT_STATUS")
  NOTIFY_PAYMENT_FINAL_STATUS = MethodType.new("NOTIFY_PAYMENT_FINAL_STATUS")
  PAYMENT = MethodType.new("PAYMENT")
end

# {http://www.telefonica.com/schemas/UNICA/RPC/payment/v1}TransactionEnumerationType
class TransactionEnumerationType < ::String
  FAILURE = TransactionEnumerationType.new("FAILURE")
  PENDING = TransactionEnumerationType.new("PENDING")
  SUCCESS = TransactionEnumerationType.new("SUCCESS")
end


end; end
