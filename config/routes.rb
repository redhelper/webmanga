Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get '/mangas' => 'mangas#index'
  resources :mangas do
    collection do
      get 'search'
    end
  end
  root 'mangas#index'
end
