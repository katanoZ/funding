class Administrator::InvestmentsController < Administrator::BaseController
  def index
    @investments = Investment.includes(:user, :project).order(created_at: :desc)
  end
end
