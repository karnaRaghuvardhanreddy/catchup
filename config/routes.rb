Rails.application.routes.draw do
  authenticated :user do
    root 'thoughts#index', as: :authenticated_root
  end
  unauthenticated do
    root 'devise/sessions#new', as: :unauthenticated_root
  end
  devise_for :users
  devise_scope :user do
    get "users/sign_out", to: "devise/sessions#destroy"
  end
  resources :thoughts, only: [:index, :new, :create, :destroy] do
    resources :likes, only: [:create, :destroy]
  end
  resources :friendships, only: [:index, :create, :update, :destroy]
  resource :profile, only: [:show, :edit, :update]
  resources :users, only: [:index, :show]
end
