# frozen_string_literal: true

Rails.application.routes.draw do
  get '/:locale' => 'landing#index'
  root to: 'landing#index'

  scope '(:locale)', locale: /en|ru/ do
    resources :sites
  end
end
