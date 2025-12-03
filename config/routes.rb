Rails.application.routes.draw do
  # 1. コントローラーを指定する
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions'
  }

  # 2. ゲストログイン用のURLを追加
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  # 3. 各ルーティング
  root to: 'homes#index'
  resources :partner_statuses, only: [:create]
  resources :consultations, only: [:index, :create, :destroy]
  resources :schedules, only: [:new, :create, :destroy]
end
