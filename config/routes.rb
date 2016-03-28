Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'
  get    'signup',  to: 'users#new'
  get    'login',   to: 'sessions#new'
  post   'login',   to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'
  get    'alluser', to: 'users#all'
  get    'help',    to: 'static_pages#help'

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
  resources :retweets, only: [:create, :destroy]

  # 該当しないパスだったら、'/'へ飛ばす
  get '*anything' => redirect('/')
end
