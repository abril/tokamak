require File.expand_path(File.dirname(__FILE__) + '/../../tokamak.rb') unless defined? ::Tokamak

module Tokamak
  module RegistryContainer
    
    def tokamak_registry
      @tokamak || use_tokamak
    end
    
    def use_tokamak(&block)
      @tokamak = ::Tokamak::Registry.new
      if block_given?
        yield @tokamak
      else
        @tokamak << ::Tokamak::Builder::Json
        @tokamak << ::Tokamak::Builder::Xml
      end
      @tokamak
    end
    
  end
end

module ActionController
  class Base
    include Tokamak::RegistryContainer
  end
end

module Tokamak
  module Hook
    module Rails

      class Tokamak < ::ActionView::TemplateHandler
        include ::ActionView::TemplateHandlers::Compilable

        def compile(template)
          "@content_type_helpers = @controller.tokamak_registry[self.response.content_type].helper; " +
          "extend @content_type_helpers; " +
          "extend Tokamak::Hook::Rails::Helpers; " +
          "code_block = lambda { #{template.source} };" +
          "builder = code_block.call; " +
          "builder"
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
          template = _pick_partial_template(partial_path)

          # Create a context to assing variables
          if caller_binding.kind_of?(Hash)
            Proc.new do
              extend @content_type_helpers
              context = eval("(class << self; self; end)", binding)

              unless caller_binding[:locals].nil?
                caller_binding[:locals].each do |k, v|
                  context.send(:define_method, k.to_sym) { v }
                end
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
