Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process

  mount ActionCable.server => '/cable'

  root to: 'static#home'
  get '/coming_soon', to: 'static#coming_soon'
  get '/que_es', to: 'static#que_es'
  get '/como_funciona', to: 'static#como_funciona'
  get '/testimonios', to: 'static#testimonios'
  get '/contacto', to: 'static#contacto'

  get '/my_dashboard',  to: 'users#dashboard', as: 'user_dashboard'

  get '/my_referrals',  to: 'users#my_referrals'

  post '/send_donation',  to: 'users#donation_send'

  post '/request_donation', to: 'users#donation_request'

  post '/add_invoice', to: 'transactions#add_invoice'

  get '/confirm_transaction', to: 'transactions#confirm_transaction', as: 'transaction_confirm'

  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :donations

  resources :chats do
    resources :messages
  end

  get '/coming_soon',  to: 'static#coming_soon', as: 'coming'

  get '/account_balance',  to: 'users#account_balance'

  get '/news',  to: 'users#news'

end
