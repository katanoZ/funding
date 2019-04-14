Rails.application.routes.draw do
  devise_for :users

  root 'admin/projects#index'

  namespace :admin do
    root 'projects#index'
    resources :projects
  end
end
