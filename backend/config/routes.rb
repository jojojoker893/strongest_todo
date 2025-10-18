Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health_check", to: "health_check#index"
      resources :users, only: [:create, :index, :show]
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:update, :show, :destory, :index, :create]
    end
  end
end
