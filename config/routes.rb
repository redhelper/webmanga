Rails.application.routes.draw do
  resources :reviews
  devise_for :users
  get 'home/index'
  get '/mangas' => 'mangas#index'
  get 'mangas/friends'
  post '/mangas/friends/friend_invite' => 'mangas#friend_invite'
  resources :mangas do
    collection do
      get 'search'
    end
  end
  root 'mangas#index'
end
