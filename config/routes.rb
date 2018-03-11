Rails.application.routes.draw do

  get 'errors/show404'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    #omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root to: 'home#index'
  get 'about', to: "home#about", as: :about
  get 'help', to: "home#help", as: :help

  #get ':login', to: "profiles#show", as: :profile
  #get ':login/settings', to: "profiles#edit", as: :profile_settings

  # get 'profile', to: "profiles#show", param: :login, as: :profile
  # get 'settings', to: "profiles#edit", param: :login, as: :profile_settings
  # post 'settings', to: "profiles#update", param: :login, as: :profile_settings 
  #resources :profiles, param: :login, only: [:show, :edit, :update]

  scope ':login' do
    get 'profile', to: "profiles#show", as: :profile
    get 'settings', to: "profiles#edit", as: :profile_edit
    post 'settings', to: "profiles#update"

    resources :documents, param: :iid, only: [:index, :show, :edit, :destroy] do
      get 'page/:page', action: :index, on: :collection # for kaminari
      get 'folder/:folder', action: :index, on: :collection, as: :folder
      get 'folder/:folder/page/:page', action: :index, on: :collection # for kaminari
      resources :permissions, shallow: true
      resources :logs, only: [:index, :show], controller: 'document/logs'
    end

    resources :tasks do
      resources :logs, only: [:index, :show], controller: 'task/logs'
    end

    resources :scripts do
      get 'page/:page', action: :index, on: :collection # for kaminari
    end
  end

  get '*path', to: "errors#show404"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
