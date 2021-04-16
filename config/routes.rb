# frozen_string_literal: true

Rails.application.routes.draw do
  resources :boards, only: %i[new create show]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :boards, only: [], shallow: true do
        resources :lists, only: %i[create destroy update]
      end
    end
  end

  root to: redirect(path: 'boards/new', status: 302)
end
