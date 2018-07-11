Rails.application.routes.draw do
  root to: 'events#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout

  resources :events
end
