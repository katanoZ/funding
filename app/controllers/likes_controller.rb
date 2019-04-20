class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    project = Project.find(params[:like][:project_id])
    current_user.like!(project)
    redirect_back(fallback_location: projects_path)
  end

  def destroy
    project = Like.find(params[:id]).project
    current_user.remove_like!(project)
    redirect_back(fallback_location: projects_path)
  end
end
