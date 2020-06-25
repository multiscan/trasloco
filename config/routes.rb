# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    # omniauth_callbacks: 'omni_auth'
  }
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    get 'sign_up', to: 'users/registrations#new'
    get 'forgot_password', to: 'users/passwords#new'
    get 'reset_password', to: 'users/passwords#edit'
  end

  resources :todos do
    get 'suggest', :action=>"suggest_new", :as=>'suggest', :on=>:collection
    post 'suggest', :action=>"suggest_create", :as=>'create', :on=>:collection
    put 'sort', :action=>"sort", :as=>'sort', :on=>:collection
  end

  resources :boxes
  resource  :move, :only=>[:edit,:update]
  resources :rooms do
    resources :boxes, :only=>[:new]
  end
  get '/dashboard', to: 'home#dashboard', :as=>'dashboard'

  root :to => "home#dashboard"
  # root to: 'application#home'
end
