class MainController < ApplicationController
  skip_before_action :authorize, only: :index
  def index
  end

  def abot
  end
end
