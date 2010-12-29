require "nokogiri"

module Tokamak
  module Builder
    class Xml < Tokamak::Builder::Base

      builder_for "application/xml", "text/xml"

      attr_reader :raw

      def initialize(obj, options = {})
        @raw = Nokogiri::XML::Document.new
        @obj = obj
        @parent = @raw.create_element(options[:root] || "root")
        @parent.parent = @raw
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
          attr = key.to_s
          if attr =~ /^xmlns(:\w+)?$/
            ns = attr.split(":", 2)[1]
            @parent.add_namespace_definition(ns, value)
          end
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
        node = create_element(name.to_s, prefix, *args)
        node.parent = @parent
        if block_given?
          @parent = node
          block.call
          @parent = node.parent
        end
      end

      def representation
        @raw.to_xml
      end

    private

      def create_element(node, prefix, *args)
        node = @raw.create_element(node) do |n|
          if prefix
            if namespace = prefix_valid?(prefix)
              # Adding namespace prefix
              n.namespace = namespace
              namespace = nil
            end
          end

          args.each do |arg|
            case arg
            # Adding XML attributes
            when Hash
              arg.each { |k,v|
                key = k.to_s
                if key =~ /^xmlns(:\w+)?$/
                  ns_name = key.split(":", 2)[1]
                  n.add_namespace_definition(ns_name, v)
                  next
                end
                n[k.to_s] = v.to_s
              }
            # Adding XML node content
            else
              content = arg.kind_of?(Time) || arg.kind_of?(DateTime) ? arg.xmlschema : arg
              n.content = content
            end
          end
        end
      end

      def prefix_valid?(prefix)
        ns = @parent.namespace_definitions.find { |x| x.prefix == prefix.to_s }

        unless ns
          @parent.ancestors.each do |a|
            next if a == @raw
            ns = a.namespace_definitions.find { |x| x.prefix == prefix.to_s }
            break if ns
          end
        end

        return ns
      end

    end
  end
end
