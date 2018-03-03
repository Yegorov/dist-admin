class ErrorsController < ApplicationController
  def show404
    render status: 404
  end
end
