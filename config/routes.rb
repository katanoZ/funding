Rails.application.routes.draw do
  devise_for :users

  root 'projects#index'
  resources :projects, only: %i[index show]

  # マイプロジェクト画面
  namespace :admin do
    root 'projects#index'
    resources :projects
  end
end
