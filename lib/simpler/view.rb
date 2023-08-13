# frozen_string_literal: true

require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'

    def initialize(env)
      @env = env
    end

    def render(binding)
      view_type = @env['simpler.response.header'][/\/(.+\z)/, 1].capitalize

      Object.const_get("#{view_type}View").new(@env).call(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      @env['simpler.template'] = path

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
