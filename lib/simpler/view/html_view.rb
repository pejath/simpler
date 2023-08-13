# frozen_string_literal: true

class HtmlView < Simpler::View
  def call(binding)
    template = File.read(template_path)

    ERB.new(template).result(binding)
  end
end
