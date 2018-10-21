Rails.application.routes.draw do
  get 'user_homepage/index'
  get 'homepage/index'

  #Profile routes
  get 'profile', to: 'people#show'
  get 'profile/edit', to: 'people#edit'
  put 'profile', to: 'people#update'

  root 'homepage#index'
  devise_for :users, controllers: {registrations: 'users/registrations',sessions: 'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  # As a note, you can create resources with 'only' to create only some of the routes
  # #resources :people, only: [:edit, :update, :show]
end
