Rails.application.routes.draw do
  root 'lists#index'

  match "/" => "list#index", as: :index, via: [:get, :post]
  post 'post_new_card', action: :post_new_card, controller: 'lists'
  match 'handle_webhook' => "lists#handle_webhook", via: [:all]
  # match 'handle_webhook', to: "list",  via: :all
  patch 'move_card', action: :move_card, controller: 'lists'
  resources :lists

end
