Rails.application.routes.draw do
  devise_for :users

  root 'projects#index'
  resources :projects, only: %i[index show] do
    resources :investments, only: %i[new create]
  end

  # マイプロジェクト画面
  namespace :admin do
    root 'projects#index'
    resources :projects
  end

  resources :likes, only: %i[create destroy]
end
