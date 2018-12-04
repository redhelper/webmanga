Rails.application.routes.draw do
  get 'home/index'
  get '/mangas' => 'mangas#index'
  resources :mangas
  root 'mangas#index'
end
