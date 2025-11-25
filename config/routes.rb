Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#index'
  resources :partner_statuses, only: [:create]
  resources :consultations, only: [:index, :show, :create]
  resources :schedules, only: [:new, :create, :destroy]
end
