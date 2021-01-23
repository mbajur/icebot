# typed: strict
Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users

  namespace :panel do
    resources :projects, except: [:new, :edit, :update] do
      get :github, on: :new, action: :new_github
    end
  end

  namespace :inbox do
    post 'v1/report', to: 'v1#report'
  end

  match '/auth/:provider/callback', to: 'authorizations#create', via: [:get, :post]

  get '/github/*full_name', to: 'projects#show', as: :project
  # resources :projects, only: [:show]
end
