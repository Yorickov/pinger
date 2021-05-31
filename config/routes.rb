# frozen_string_literal: true

# == Route Map
#
#    Prefix Verb   URI Pattern                         Controller#Action
#     sites GET    (/:locale)/sites(.:format)          sites#index {:locale=>/en|ru/}
#           POST   (/:locale)/sites(.:format)          sites#create {:locale=>/en|ru/}
#  new_site GET    (/:locale)/sites/new(.:format)      sites#new {:locale=>/en|ru/}
# edit_site GET    (/:locale)/sites/:id/edit(.:format) sites#edit {:locale=>/en|ru/}
#      site GET    (/:locale)/sites/:id(.:format)      sites#show {:locale=>/en|ru/}
#           PATCH  (/:locale)/sites/:id(.:format)      sites#update {:locale=>/en|ru/}
#           PUT    (/:locale)/sites/:id(.:format)      sites#update {:locale=>/en|ru/}
#           DELETE (/:locale)/sites/:id(.:format)      sites#destroy {:locale=>/en|ru/}
#           GET    /:locale(.:format)                  landing#index
#      root GET    /                                   landing#index

Rails.application.routes.draw do
  devise_for :users

  scope '(:locale)', locale: /en|ru/ do
    resources :sites
  end

  get '/:locale' => 'landing#index'
  root to: 'landing#index'
end
