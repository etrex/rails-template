Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: "home#index"
  get :index, to: "home#index"

  # 加入好友時的自我介紹訊息
  get "follow", to: "home#index"

  get :index, to: "home#index"
  get :terms, to: "home#terms"
  get :about, to: "home#about"
  post :contact_request, to: "home#contact_request"
  get :privacy, to: "home#privacy"
end
