Rails.application.routes.draw do

  post 'post_new_card', action: :post_new_card, controller: 'cards'
  resources :cards do
    member do
      patch  :move
      post :post_new_card
    end
  end
  resources :lists
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
