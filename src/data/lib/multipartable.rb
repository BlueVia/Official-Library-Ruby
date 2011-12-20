#require 'parts'
  module Multipartable
    DEFAULT_BOUNDARY = "-----------RubyMultipartPost"
    def initialize(path, params, headers={}, boundary = DEFAULT_BOUNDARY)
      super(path, headers)
      parts = params.map {|k,v| Parts::Part.new(boundary, k, v)}
      parts << Parts::EpiloguePart.new(boundary)
      ios = parts.map{|p| p.to_io }
      self.set_content_type("multipart/form-data", { "boundary" => boundary })
      # smoking area
      # content_length is invalid and it deletes 2 bytes per part in multipart
      self.content_length = parts.inject(-2) {|sum,i| sum + (i.length + 2)}
      self.body_stream = CompositeReadIO.new(*ios)
    end
  end