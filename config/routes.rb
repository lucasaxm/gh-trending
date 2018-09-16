Rails.application.routes.draw do
  resources :repositories, only: %i[index show]
  resources :owners, only: :show
  resources :trending, only: :index, path: '/'
  get '/search', action: :search, controller: :trending
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
