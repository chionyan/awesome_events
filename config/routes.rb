Rails.application.routes.draw do
  root to: 'events#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout
  get '/users/retire' => 'users#retire', as: :user_retire

  resources :events do
    resources :tickets, only: [:create, :destroy]
  end
end
