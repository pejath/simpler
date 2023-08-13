# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    # render plain: 'Plain text response'
    @time = Time.now
  end

  def create
    render plain: 'Created'
    status 201
  end

  def show
    @id = params[:id]
  end
end
