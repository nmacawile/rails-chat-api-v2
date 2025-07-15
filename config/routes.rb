Rails.application.routes.draw do
  # devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "/signup" => "users#create"
      post "/auth/login" => "authentication#login"

      get "users" => "users#index"
      
      patch "visibility" => "visibility#update"
      
      get "chats" => "chats#index"
      get "chats/:id" => "chats#show"
      post "chats/find_or_create/:user_id" => "chats#find_or_create"

      get "chats/:chat_id/messages" => "messages#index"
      post "chats/:chat_id/messages" => "messages#create"
    end

    mount ActionCable.server => "/cable"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
