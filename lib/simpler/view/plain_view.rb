# frozen_string_literal: true

class PlainView < Simpler::View
  def call(_binding)
    @env['simpler.template']
  end
end
