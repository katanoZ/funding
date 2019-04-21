class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    project = Project.find(params[:project_id])
    if current_user.like(project)
      redirect_back(fallback_location: projects_path)
    else
      redirect_to projects_path, alert: '処理に失敗しました'
    end
  end

  def destroy
    project = Like.find(params[:id]).project
    if current_user.remove_like(project)
      redirect_back(fallback_location: projects_path)
    else
      redirect_to projects_path, alert: '処理に失敗しました'
    end
  end
end
