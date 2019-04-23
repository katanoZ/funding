class Administrator::InvestmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_administrator

  def index
    @investments = Investment.includes(:user, :project).order(created_at: :desc)
  end

  private

  def check_administrator
    redirect_to root_path unless current_user.administrator?
  end
end
