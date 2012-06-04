#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

%w[bv_advertising bv_directory bv_location bv_mo_sms bv_mo_mms bv_mt_sms bv_mt_mms bv_oauth bv_payment].each{|client|  require "bluevia/clients/#{client}"}

%w[config].each{|file|  require "bluevia/#{file}"}


# Main Bluevia module definition
module Bluevia

  BASE_URI= "https://api.bluevia.com"
  
  VERSION = "1.6"
end
