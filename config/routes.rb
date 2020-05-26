Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users

  namespace :panel do
    resources :projects
  end

  namespace :inbox do
    post 'v1/report', to: 'v1#report'
  end
end
