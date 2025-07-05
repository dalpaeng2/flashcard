Rails.application.routes.draw do
  get "decks", to: "decks#index", as: :decks
  post "decks", to: "decks#create"
  get "decks/new", to: "decks#new", as: :new_deck
  get "decks/:id", to: "decks#show", as: :deck
  get "decks/:id/edit", to: "decks#edit", as: :edit_deck
  patch "decks/:id", to: "decks#update"
  put "decks/:id", to: "decks#update"
  delete "decks/:id", to: "decks#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "decks#index"
end
