# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  scope '(:locale)', locale: /en|ru/ do
    resources :sites
  end

  get '/:locale' => 'landing#index'
  root to: 'landing#index'
end
