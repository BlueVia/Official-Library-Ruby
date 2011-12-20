require 'nokogiri'

#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com
# 
# Extension of Hash to create a Hash table using as input an XML
# that should be decoded using Nokogiri library
#
class Hash
  class << self
    def from_xml(xml_io)
      begin
        result = Nokogiri::XML(xml_io)
        return { result.root.name.to_sym => xml_node_to_hash(result.root)}
      rescue Exception => e
        raise e
      end
    end

    def xml_node_to_hash(node)
      # If we are at the root of the document, start the hash
      if node.element?
        result_hash = {}
        if node.attributes != {}
          result_hash[:attributes] = {}
          node.attributes.keys.each do |key|
            result_hash[:attributes][node.attributes[key].name.to_sym] = prepare(node.attributes[key].value)
          end
        end
        if node.children.size > 0
          node.children.each do |child|
            result = xml_node_to_hash(child)

            if child.name == "text"
              unless child.next_sibling || child.previous_sibling
                return prepare(result)
              end
            elsif result_hash[child.name.to_sym]
              if result_hash[child.name.to_sym].is_a?(Object::Array)
                result_hash[child.name.to_sym] << prepare(result)
              else
                result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << prepare(result)
              end
            else
              result_hash[child.name.to_sym] = prepare(result)
            end
          end

          return result_hash
        else
          return result_hash
        end
      else
        return prepare(node.content.to_s)
      end
    end

    def prepare(data)
      (data.class == String && data.to_i.to_s == data) ? data.to_i : data
    end
  end
end
