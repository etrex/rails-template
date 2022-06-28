Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: "home#index"
  get :index, to: "home#index"

  # 加入好友時的自我介紹訊息
  get "follow", to: "home#index"
end