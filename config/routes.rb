Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  root 'static_pages#home'

  get 'static_pages/home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/spotify', to: 'static_pages#spotify'
  get '/spotify_helper', to: 'static_pages#spotify_helper'
  get '/auth/spotify/callback', to: 'users#spotify'

  get 'sessions/new'
  get 'users/new'

  get 'welcome/index'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :admin

  resources :communities do
    put "like", to: "communities#upvote"
    put "dislike", to: "communities#downvote"

    resources :microposts do

      member do
        put "like", to: "microposts#upvote"
        put "dislike", to: "microposts#downvote"
      end
    end
  end

  resources :microposts do

    resources :polycoms, module: :microposts

    put "like", to: "microposts#upvote"
    put "dislike", to: "microposts#downvote"

  end

  resources :polycoms do
    resources :polycoms, module: :polycoms

    put "like", to: "polycoms#upvote"
    put "dislike", to: "polycoms#downvote"
  end




  resources :playlists do
  	put "addpost/:post_id", to: "playlists#addpost", as: 'addpost'
  end


  get '/new', to: 'microposts#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
