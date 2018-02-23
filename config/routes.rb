Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    #omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root to: 'home#index'
  get '/about', to: "home#about", as: :about

  get ':login', to: "profile#show", as: :profile
  get ':login/settings', to: "profile#edit", as: :profile_settings

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
