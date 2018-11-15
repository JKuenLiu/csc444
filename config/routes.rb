Rails.application.routes.draw do
  get 'homepage/index'

  get 'homepage/history'
  get 'homepage/notifications'
  post 'homepage/approve_request'

  #Profile routes
  get 'profile', to: 'people#show'
  get 'profile/edit', to: 'people#edit'
  put 'profile', to: 'people#update'

  #get 'item/index', to: 'item#index'
  #get 'item/show', to: 'item#show'
  #get 'item/update', to: 'item#update'
  #get 'item/edit', to: 'item#edit'

  #TODO: Define the routes to create transactions hierarchically under an item; each transaction .only has one item
  resources :items
  post 'items/request_item'
  post 'items/return_item'

  root 'homepage#index'
  devise_for :users, controllers: {registrations: 'users/registrations',sessions: 'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  # As a note, you can create resources with 'only' to create only some of the routes
  # #resources :people, only: [:edit, :update, :show]
end
