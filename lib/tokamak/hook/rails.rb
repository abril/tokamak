require File.expand_path(File.dirname(__FILE__) + '/../../tokamak.rb') unless defined? ::Tokamak

module Tokamak
  module Hook
    module Rails

      class Tokamak < ::ActionView::TemplateHandler
        include ::ActionView::TemplateHandlers::Compilable

        def compile(template)
          "@content_type_helpers = ::Tokamak.builder_lookup(self.response.content_type).helper; " +
          "extend @content_type_helpers; " +
          "extend Tokamak::Hook::Rails::Helpers; " +
          "code_block = lambda { #{template.source} };" +
          "builder = code_block.call; " +
          "builder"
        end
      end

      module Rails3Adapter
        def _pick_partial_template(path) #:nodoc:
          return path unless path.is_a?(String)
          prefix = controller_path unless path.include?(?/)
          find_template(path, prefix, true).instance_eval do
            unless respond_to?(:path)
              def path; virtual_path end
            end
            self
          end
        end
      end

      module Helpers
        # Load a partial template to execute in describe
        #
        # For example:
        #
        # Passing the current context to partial in template:
        #
        #  member(@album) do |member, album|
        #    partial('member', binding)
        #  end
        #
        # in partial:
        #
        #  member.links << link(:rel => :artists, :href => album_artists_url(album))
        #
        # Or passing local variables assing
        #
        # collection(@albums) do |collection|
        #   collection.members do |member, album|
        #     partial("member", :locals => {:member => member, :album => album})
        #   end
        # end
        #
        def partial(partial_path, caller_binding = nil)
          begin
            template = _pick_partial_template(partial_path)
          rescue NoMethodError
            self.extend(Rails3Adapter)
            template = _pick_partial_template(partial_path)
          end

          # Create a context to assing variables
          if caller_binding.kind_of?(Hash)
            Proc.new do
              extend @content_type_helpers
              context = eval("(class << self; self; end)", binding)

              caller_binding.fetch(:locals, {}).each do |k, v|
                context.send(:define_method, k.to_sym) { v }
              end

              partial(partial_path, binding)
            end.call
          else
            eval(template.source, caller_binding, template.path)
          end
        end
      end

      if defined? ::ActionView::Template and ::ActionView::Template.respond_to?(:register_template_handler)
        ::ActionView::Template
      else
        if defined? ::ActionController::Base
          ::ActionController::Base.exempt_from_layout :tokamak
        end
        ::ActionView::Base
      end.register_template_handler(:tokamak, Tokamak)

    end
  end
end
