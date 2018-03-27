Rails.application.routes.draw do

  namespace :task do
    get 'logs/index'
  end

  namespace :task do
    get 'logs/show'
  end

  mount RailsAdmin::Engine => 'administrator', as: 'rails_admin'
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

    resources :documents, param: :iid, except: [:new, :create] do
      get 'page/:page', action: :index, on: :collection # for kaminari
      get 'folder/:folder', action: :index, on: :collection, as: :folder
      get 'folder/:folder/page/:page', action: :index, on: :collection # for kaminari

      get 'new-file', action: :new_file, on: :collection, as: :new_file
      post 'new-file', action: :create_file, on: :collection

      get 'new-folder', action: :new_folder, on: :collection, as: :new_folder
      post 'new-folder', action: :create_folder, on: :collection

      resources :permissions, except: [:new, :edit, :update, :destroy] do
        get 'new', action: :new, on: :collection, as: :new
        get ':user_login', action: :index_show, on: :collection, as: :index_show
        get ':user_login/edit', action: :edit, on: :collection, as: :edit
        patch ':user_login', action: :update, on: :collection, as: :update
      end
      resources :logs, only: [:index, :show], controller: 'document/logs'
    end

    resources :tasks, only: [:index, :show, :new, :create] do
      resources :logs, only: [:index, :show], controller: 'task/logs' do
        get 'page/:page', action: :index, on: :collection # for kaminari
      end
      post 'start', on: :member, as: :start
      post 'restart', on: :member, as: :restart
      post 'stop', on: :member, as: :stop
    end

    resources :scripts do
      get 'page/:page', action: :index, on: :collection # for kaminari
    end
  end

  get '*path', to: "errors#show404"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
