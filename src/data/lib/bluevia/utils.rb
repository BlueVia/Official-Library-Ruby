#
# BlueVia is a global iniciative of Telefonica delivered by Movistar and O2.
# Please, check out www.bluevia.com and if you need more information
# contact us at mailto:support@bluevia.com

require 'mime/types'
require 'net/http'
require 'multipartable'
require 'bluevia/errors/client_error'

module Bluevia
  #
  # Helper to enable internal features
  #

  module Utils

    class Multipart < Net::HTTP::Post
      include Multipartable

      def set_content_type(type, params = {})

      end

      def content_length=(len)

      end
    end

    def Utils.get_file_mime_type(file)
      unless file.nil?
        mime = MIME::Types.type_for(file)
        mime.to_s
      else
        nil
      end
    end

    #
    # Helper to parse an objet to an equivalent JSON format
    # used to serialize body data
    #
    def Utils.object_to_json(object)
      name = object.class.to_s
      name = name[name.rindex(":")+1..name.size].sub(/Type$/,"").sub(/^SMS/, "sms")
      name = name[0..0].to_s.downcase << name[1..name.size]
      result = Hash.new
      result[name] = _object_to_json(object)
      return result.to_json

      #return _object_to_json(object).to_json
    end

    #
    # Check if an attribute is not null
    # Raise an exception in case of param.nil?
    #
    def Utils.check_attribute(attribute, message)
      if attribute.nil?
        raise ClientError, message
      elsif attribute.instance_of?(String)
        if attribute.empty?
          raise ClientError, message
        end
      else
        if attribute.respond_to?(:size)
          if attribute.size == 0
            raise ClientError, message
          end
        end
      end
    end


    private

    def Utils._object_to_json(object)
      result = Hash.new
      #result_aux = []
      object.instance_variables.each do |column|
        aux = object.instance_variable_get(column)
        unless aux.nil?
          if aux.instance_of?(String) or aux.kind_of?(String)
            # It's required to erase any '_' character because
            # soap4r has included it (not idea about the reason)
            result[get_column_value(column)] = aux.to_s
          else
            if aux.instance_of?(Array)
              result_aux = Array.new
              aux.each do |elem|
                result_aux << _object_to_json(elem)
              end
            else
              result_aux = _object_to_json(aux)
            end
            result[get_column_value(column)] = result_aux
            #result_aux =[]
          end
        end
      end
      return result
    end

    def Utils.get_column_value(column)
      column = column.to_s.sub(/@/,'')
      unless column.index('_').nil?
        column = column.split('_')[1]
      end
      column
    end
  end
end