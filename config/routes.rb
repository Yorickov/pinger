# frozen_string_literal: true

# == Route Map
#
#                   Prefix Verb   URI Pattern                         Controller#Action
#         new_user_session GET    /users/sign_in(.:format)            devise/sessions#new
#             user_session POST   /users/sign_in(.:format)            devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)           devise/sessions#destroy
#        new_user_password GET    /users/password/new(.:format)       devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)      devise/passwords#edit
#            user_password PATCH  /users/password(.:format)           devise/passwords#update
#                          PUT    /users/password(.:format)           devise/passwords#update
#                          POST   /users/password(.:format)           devise/passwords#create
# cancel_user_registration GET    /users/cancel(.:format)             devise/registrations#cancel
#    new_user_registration GET    /users/sign_up(.:format)            devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)               devise/registrations#edit
#        user_registration PATCH  /users(.:format)                    devise/registrations#update
#                          PUT    /users(.:format)                    devise/registrations#update
#                          DELETE /users(.:format)                    devise/registrations#destroy
#                          POST   /users(.:format)                    devise/registrations#create
#                    sites GET    (/:locale)/sites(.:format)          sites#index {:locale=>/en|ru/}
#                          POST   (/:locale)/sites(.:format)          sites#create {:locale=>/en|ru/}
#                 new_site GET    (/:locale)/sites/new(.:format)      sites#new {:locale=>/en|ru/}
#                edit_site GET    (/:locale)/sites/:id/edit(.:format) sites#edit {:locale=>/en|ru/}
#                     site GET    (/:locale)/sites/:id(.:format)      sites#show {:locale=>/en|ru/}
#                          PATCH  (/:locale)/sites/:id(.:format)      sites#update {:locale=>/en|ru/}
#                          PUT    (/:locale)/sites/:id(.:format)      sites#update {:locale=>/en|ru/}
#                          DELETE (/:locale)/sites/:id(.:format)      sites#destroy {:locale=>/en|ru/}
#                          GET    /:locale(.:format)                  landing#index
#                     root GET    /                                   landing#index
require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :sites, except: %i[new create]
    resources :logs, only: %i[index show destroy]

    root to: 'users#index'
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  scope '(:locale)', locale: /en|ru/ do
    resources :sites do
      get :ping_current, on: :member
      patch :ping_change, on: :member
      get :ping_new, on: :collection

      resources :logs, only: %i[index]
    end
  end

  get '/:locale' => 'landing#index'
  root to: 'landing#index'
end
