Rails.application.routes.draw do
  resources :contact_messages
 
  resources :articles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  require 'sidekiq/web'

  authenticate :user, lambda { |u| u.has_role? :developer } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  mount ActionCable.server => '/cable'

  root to: 'static#home'
  get '/coming_soon', to: 'static#coming_soon'
  get '/que_es', to: 'static#que_es'
  get '/como_funciona', to: 'static#como_funciona'
  get '/testimonios', to: 'static#testimonios'
  get '/contacto', to: 'static#contacto'

  get '/my_dashboard',  to: 'users#dashboard', as: 'user_dashboard'

  get '/my_referrals',  to: 'users#my_referrals'

  post '/notifications', to: 'users#notifications', as: 'readed'

  post '/send_donation',  to: 'users#donation_send'

  post '/request_donation', to: 'users#donation_request'

  post '/add_invoice', to: 'transactions#add_invoice'

  get '/confirm_transaction', to: 'transactions#confirm_transaction', as: 'transaction_confirm'

  devise_for :users, controllers: { registrations: 'registrations', confirmations: 'confirmations' }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :donations

  post 'test', to: 'users#test', as: 'test'


  resources :chats do
    resources :messages
  end

  get '/coming_soon',  to: 'static#coming_soon', as: 'coming'

  get '/account_balance',  to: 'users#account_balance'

  get '/news',  to: 'users#news'


  #admin dashboard routes
  get '/admin_dashboard', to: 'admin_dashboard#dashboard_home'

  get '/users_admin', to: 'admin_dashboard#users_admin'

  get '/users/:id', to: 'users#show', as: 'user_show'

  get '/donations_admin', to: 'admin_dashboard#donations_admin'

  get '/my_transactions', to: 'admin_dashboard#owner_transactions'

  get '/donations/:id', to: 'donations#show', as: 'donation_show'

  get '/requests_admin', to: 'admin_dashboard#requests_admin'

  get '/requests/:id', to: 'requests#show', as: 'request_show'

  get '/transactions_admin', to: 'admin_dashboard#transactions_admin'

  get '/transactions/:id', to: 'transactions#show', as: 'transaction_show'



  #Support admin routes
  get  '/admin_chats',to: 'chats#admin_index' 

  post  '/admin_messages',to: 'chats#create', as: 'support_messages'

  get  '/support_chats/:chat_id',to: 'messages#admin_index' , as: 'support_chat'
  
end
