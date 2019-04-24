class Admin::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = current_user.projects.order(created_at: :desc)
  end

  def show
  end

  def new
    @project = current_user.projects.build
    @project.categorizations.build
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to admin_projects_path, notice: "プロジェクト「#{@project.name}」を作成しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to admin_project_path(@project), notice: "プロジェクト「#{@project.name}」を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @project.destroy!
    redirect_to admin_projects_path, notice: "プロジェクト「#{@project.name}」を削除しました"
  end

  private

  def project_params
    params.require(:project).permit(
      :name, :description, :price, categorizations_attributes: [:id, :category_id]
    )
  end

  def set_project
    @project = current_user.projects.find(params[:id])
  end
end
