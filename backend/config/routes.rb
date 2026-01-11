Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health_check", to: "health_check#index"
      resources :users, only: [:create, :show, :destroy, :update]
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:update, :show, :destroy, :index, :create]
    end
  end
end
