Rails.application.routes.draw do
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
    get 'investments/report', to: 'investments#report'
  end

  # 運営管理者画面
  namespace :administrator do
    root 'investments#index'
    resources :investments, only: %i[index]
    resources :categories
  end
end
