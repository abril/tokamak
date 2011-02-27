module Tokamak
  module Builder
    class Xml < Tokamak::Builder::Base

      builder_for "application/xml", "text/xml"

      attr_reader :raw

      def initialize(obj, options = {})
        initialize_library
        @raw = Nokogiri::XML::Document.new
        @obj = obj
        @parent = @raw.create_element(options[:root] || "root")
        @parent.parent = @raw
      end

      def initialize_library
        return if defined?(::Nokogiri)
        require "nokogiri"
      end

      def members(options = {}, &block)
        collection = options[:collection] || @obj
        raise Tokamak::BuilderError.new("Members method require a collection to execute") unless collection.respond_to?(:each)
        collection.each do |member|
          member_root = @raw.create_element(options[:root] || "member")
          member_root.parent = @parent
          @parent = member_root
          block.call(self, member)
          @parent = member_root.parent
        end
      end

      def values(options = {}, &block)
        options.each do |key,value|
          apply_namespace(@parent, key.to_s, value)
        end
        yield Values.new(self)
      end

      def link(relationship, uri, options = {})
        options["rel"] = relationship.to_s
        options["href"] = uri
        options["type"] ||= options[:type] || "application/xml"
        insert_value("link", nil, options)
      end

      def insert_value(name, prefix, *args, &block)
        # Protected if empty array
        unless args.size == 1 and args.first == []
          node = create_element(name.to_s, prefix, *args)
          node.parent = @parent
          if block_given?
            @parent = node
            block.call
            @parent = node.parent
          end
        end
      end

      def representation
        @raw.to_xml
      end

    private

      def apply_namespace(node, key, value)
        if key =~ /^xmlns(:\w+)?$/
          ns_name = key.split(":", 2)[1]
          node.add_namespace_definition(ns_name, value)
          return true
        end
        false
      end

      def create_element(node, prefix, *args)
        n = @raw.create_element(node)
        if prefix
          if namespace = find_prefix(prefix)
            n.namespace = namespace
          end
        end

        args.each do |arg|
          if arg.kind_of? Hash
            # Adding XML attributes
            arg.each { |k,v|
              key = k.to_s
              n[key] = v.to_s unless apply_namespace(n, key, v)
            }
          elsif arg.kind_of?(Time) || arg.kind_of?(DateTime)
            # Adding XML node content
            n.content = arg.xmlschema
          else
            n.content = arg
          end
        end
        n
      end

      def find_prefix(prefix)
        all = [@parent] + @parent.ancestors
        all.each do |a|
          return a.namespace_definitions.find { |x| x.prefix == prefix.to_s } if a != @raw
        end
      end

    end
  end
end
