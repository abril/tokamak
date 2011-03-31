module Tokamak
  module Builder
    class Json < Tokamak::Builder::Base

      builder_for "application/json"

      attr_reader :raw

      def initialize(obj, options = {})
        initialize_library
        @raw     = options[:root] ? { options[:root] => {} } : {}
        @current = options[:root] ? @raw[options[:root]]     : @raw
        @obj     = obj
      end

      def initialize_library
        return if defined?(::JSON)
        require "json/pure"
      end

      def members(options = {}, &block)
        collection = options[:collection] || @obj
        raise Tokamak::BuilderError.new("Members method require a collection to execute") unless collection.respond_to?(:each)
        root = options[:root] || "members"

        add_to(@current, root, [])
        collection.each do |member|

          parent = @current
          @current = {}
          block.call(self, member)
          add_to(parent, root, @current)
          @current = parent

        end
      end

      def values(options = {}, &block)
        yield Values.new(self)
      end

      def link(relationship, uri, options = {})
        # Start link array
        @current["link"] = [] unless @current["link"]
        stringify_keys(options) 

        options["rel"]  = relationship.to_s
        options["href"] = uri
        options["type"] ||= "application/json"
        insert_value("link", nil, options)
      end

      def insert_value(name, prefix, *args, &block)
        node = create_element(block_given?, *args)

        if block_given?
          parent = @current
          @current = node
          block.call
          @current = parent
        end

        add_to(@current, name, node)
      end

      def representation
        @raw.to_json
      end

    private

      def create_element(has_block, *args)
        vals = []
        hashes = []

        args.each do |arg|
          arg.kind_of?(Hash) ? hashes << arg : vals << arg
        end

        if hashes.empty?
          # only simple values
          unless vals.empty?
            vals = vals.first if vals.size == 1
            node = has_block ? {} : vals
          else
            node = has_block ? {} : nil
          end
        else
          # yes we have hashes
          node = {}
          hashes.each { |hash| node.merge!(hash) }
          unless vals.empty?
            vals = vals.first if vals.size == 1
            node = has_block ? {} : [node, vals]
          end
          node
        end
      end

      def add_to(node, name, value)
        if node[name]
          if node[name].kind_of?(Array)
            node[name] << value
          else
            node[name] = [node[name], value]
          end
        else
          node[name] = value
        end
      end

      def stringify_keys(hash)
        hash.keys.each do |key|
          hash[key.to_s] = hash.delete(key)
        end
      end
    end
  end
end
