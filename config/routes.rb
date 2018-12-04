Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get '/mangas' => 'mangas#index'
  resources :mangas
  root 'mangas#index'
end
