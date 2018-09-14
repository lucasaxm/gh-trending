Rails.application.routes.draw do
  resources :languages
  resources :repositories
  resources :types
  resources :owners
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
