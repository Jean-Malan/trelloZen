Rails.application.routes.draw do
  root 'lists#index'
  match "/" => "list#index", as: :index, via: [:get, :post]
  post 'post_new_card', action: :post_new_card, controller: 'lists'
  patch 'move_card', action: :move_card, controller: 'lists'
  resources :lists

end
