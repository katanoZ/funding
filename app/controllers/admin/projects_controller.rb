class Admin::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  delegate :number_of_empty_categories, to: :categories_count_manager

  attr_reader :project

  def index
    @projects = current_user.projects.order(created_at: :desc)
  end

  def show
  end

  def new
    @project = current_user.projects.build
    set_empty_categories
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to admin_projects_path, notice: "プロジェクト「#{@project.name}」を作成しました"
    else
      set_empty_categories
      render :new
    end
  end

  def edit
    set_empty_categories
  end

  def update
    if @project.update(project_params)
      redirect_to admin_project_path(@project), notice: "プロジェクト「#{@project.name}」を更新しました"
    else
      set_empty_categories
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
      :name, :description, :price, project_categories_attributes: [:id, :category_id, :_destroy]
    )
  end

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def set_empty_categories
    number_of_empty_categories.times { @project.project_categories.build }
  end

  def categories_count_manager
    @categories_count_manager ||= Admin::CategoriesCountManager.new(self)
  end
end
