Rails.application.routes.draw do
  get 'favorites/create'

  get 'favorites/destroy'

  get 'sessions/new'

  root 'static_pages#home'
  get    'signup', to: 'users#new'
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'followings'
      get 'followers'
      get 'favs'
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]

  # 該当しないパスだったら、'/'へ飛ばす
  get '*anything' => redirect('/')
end
