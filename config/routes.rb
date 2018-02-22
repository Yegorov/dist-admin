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
  get '/u/:id', to: "profile#index", as: :profile

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
