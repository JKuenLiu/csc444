Rails.application.routes.draw do
  get 'homepage/index'

  resources :people

  root 'homepage#index'
  devise_for :users, controllers: {registrations: 'users/registrations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
