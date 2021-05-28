# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ru/ do
    resources :sites
  end

  get '/:locale' => 'landing#index'
  root to: 'landing#index'
end
