class InvestmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def new
    @investment = @project.investments.build(user: current_user)
  end

  def create
    @investment = @project.investments.build(investment_params)
    @investment.user = current_user

    if @investment.save
      redirect_to project_path(@project), notice: "プロジェクト「#{@project.name}」に投資しました"
    else
      render :new
    end
  end

  private

  def investment_params
    params.require(:investment).permit(:price)
  end

  def set_project
    @project = Project.investable(current_user).find(params[:project_id])
  end
end
