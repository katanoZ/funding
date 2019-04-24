class Administrator::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_administrator

  private

  def check_administrator
    redirect_to root_path unless current_user.administrator?
  end
end
