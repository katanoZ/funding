class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all.order(created_at: :desc)
  end

  def show
    @project = Project.find(params[:id])
  end
end
