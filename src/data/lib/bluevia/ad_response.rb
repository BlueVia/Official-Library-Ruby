
#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
#

module Bluevia
  #
  # Wrapper to fetch in an easy way the image or the text ad
  #
  class AdResponse < Array
    #
    # Fetch the image ad
    #
    def image
      val = self.find_all{|item| item["type_name"].eql?("image")}
      if val.instance_of?(Array) and val.length > 0
        val = val[0]
      end
      val
    end

    #
    # Fetch the text ad
    #
    def text
      val = self.find_all{|item| item["type_name"].eql?("text")}
      if val.instance_of?(Array) and val.length > 0
        val = val[0]
      end
      val
    end
  end
end