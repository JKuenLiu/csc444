Rails.application.routes.draw do

  get 'homepage/index'

  get 'homepage/history'
  #get 'homepage/notifications'
  get 'notifications', action: :index, controller: 'notifications'
  post 'homepage/approve_request'

  get 'homepage/about'
  get 'homepage/contact'
  get 'homepage/faq'
  get 'homepage/policy'
  get 'homepage/terms'

  #Profile routes
  # get 'profile', to: 'people#show'
  # get 'profile/edit', to: 'people#edit'
  # put 'profile', to: 'people#update'
  # get 'profile/new', to: 'people#new'
  resources :people do
    resources :reviews, only:[:index, :new, :create]
  end

  #get 'item/index', to: 'item#index'
  #get 'item/show', to: 'item#show'
  #get 'item/update', to: 'item#update'
  #get 'item/edit', to: 'item#edit'

  #TODO: Define the routes to create transactions hierarchically under an item; each transaction .only has one item
  resources :items do
      resources :interactions
  end

  post 'items/request_item'
  post 'items/return_item'

  root 'homepage#index'
  devise_for :users, controllers: {registrations: 'users/registrations',sessions: 'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  # As a note, you can create resources with 'only' to create only some of the routes
  # #resources :people, only: [:edit, :update, :show]
end
