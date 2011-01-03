require File.expand_path(File.dirname(__FILE__) + '/../../tokamak.rb') unless defined? ::Tokamak

module Tokamak
  module Hook
    module Tilt

      class TokamakTemplate < ::Tilt::Template
        def initialize_engine
          return if defined?(::Tokamak)
          require_template_library 'tokamak'
        end

        def prepare
          @content_type = options[:content_type]
          raise Tokamak::BuilderError.new("Content type required to build representation.") unless @content_type
        end

        def precompiled_preamble(locals)
          local_assigns = super
          <<-RUBY
            begin
              extend ::Tokamak.builder_lookup(#{@content_type.inspect}).helper
              #{local_assigns}
          RUBY
        end

        def precompiled_postamble(locals)
          <<-RUBY
            end
          RUBY
        end

        def precompiled_template(locals)
          data.to_str
        end
      end

      ::Tilt.register 'tokamak', TokamakTemplate

    end
  end
end
