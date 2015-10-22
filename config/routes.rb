Rails.application.routes.draw do
  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users do
    resources :relationships, only: [:index]
  end
  resources :relationships, only: [:create, :destroy, :index]
  resources :words, only: [:index,:show]
  resources :user_words, only: [:create, :destroy, :index]
  resources :results, only: [:index, :show]
  resources :lessons, only: [:show, :create, :update,:index]
  resources :categories, only: [:index,:show] do
    resources :lessons, only: [:show, :create, :update]
  end
  namespace :admin do
    resources :words
    resources :categories
    resources :lessons
    resources :results
  end
end
