# frozen_string_literal: true

Rails.application.routes.draw do
  resources :boards, only: [:new, :create, :show] 
  
  get '/boards', to: redirect(path: '/boards/new')
  root 'boards#new'
end
