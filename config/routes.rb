# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'landing#index'

  resources :sites, only: %i[new create]
end
