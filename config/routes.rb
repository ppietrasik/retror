# frozen_string_literal: true

Rails.application.routes.draw do
  resources :boards, only: %i[new create show]

  root to: redirect(path: 'boards/new', status: 302)
end
