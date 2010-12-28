require File.expand_path(File.dirname(__FILE__) + '/../../tokamak.rb') unless defined? ::Tokamak

module Tokamak
  module Hook
    module Rails

      class Tokamak < ::ActionView::TemplateHandler
        include ::ActionView::TemplateHandlers::Compilable

        def compile(template)
          "@content_type_helpers = ::Tokamak.builder_lookup(self.response.content_type).helper; " +
          "extend @content_type_helpers; " +
          # "extend Restfulie::Server::ActionView::Helpers; " +
          "code_block = lambda { #{template.source} };" +
          "builder = code_block.call; " +
          "builder"
        end
      end

      if defined? ::ActionView::Template and ::ActionView::Template.respond_to?(:register_template_handler)
        ::ActionView::Template
      else
        ::ActionView::Base
      end.register_template_handler(:tokamak, Tokamak)

      if defined? ::ActionController::Base
        ::ActionController::Base.exempt_from_layout :tokamak
      end

    end
  end
end
