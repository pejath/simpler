# frozen_string_literal: true

require_relative 'view'
require_relative 'view/html_view'
require_relative 'view/plain_view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response
      @request.env['simpler.response.status'] = @response.status

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
      @request.env['simpler.response.header'] = headers['Content-Type']
    end

    def headers
      @response.headers
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params'].merge!(@request.params)
    end

    def status(code)
      @response.status = code
    end

    def render(template)
      if template.is_a? String
        headers['Content-Type'] = 'text/html'
        value = template
      else
        headers['Content-Type'] = "text/#{template.keys[0]}"
        value = template.values[0]
      end

      @request.env['simpler.response.header'] = headers['Content-Type']
      @request.env['simpler.template'] = value
    end
  end
end
