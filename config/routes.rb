Rails.application.routes.draw do
  namespace :administer do
    get 'investments/index'
  end
  devise_for :users

  root 'projects#index'
  resources :projects, only: %i[index show] do
    resources :investments, only: %i[new create]
    resources :likes, only: %i[create destroy], shallow: true
  end

  # マイプロジェクト画面
  namespace :admin do
    root 'projects#index'
    resources :projects
  end

  # 運営管理車画面
  namespace :administrator do
    root 'investments#index'
    resources :investments, only: %i[index]
  end
end
