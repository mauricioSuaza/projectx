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

  get '/faq', to: 'static#faq', as: 'faq'
  get '/panel_donacion', to: 'static#panel_donacion', as: 'panel_donation'
  get '/coming_soon', to: 'static#coming_soon'
  get '/que_es', to: 'static#que_es'
  get '/como_funciona', to: 'static#como_funciona'
  get '/testimonios', to: 'static#testimonios'
  get '/contacto', to: 'static#contacto'
  get '/how', to: 'static#how', as: 'how'
  get '/my_dashboard',  to: 'users#dashboard', as: 'user_dashboard'

  get '/my_referrals',  to: 'users#my_referrals', as: 'my_referrals'

  get '/refferal_url', to: 'users#refferal_url', as: 'generate_link'

  post '/notifications', to: 'users#notifications', as: 'readed'

  post '/send_donation',  to: 'users#donation_send'

  post '/request_donation', to: 'users#donation_request'

  post '/add_invoice', to: 'transactions#add_invoice'

  post '/add_invoice_messages', to: 'messages#add_invoice'

  get '/confirm_transaction', to: 'transactions#confirm_transaction', as: 'transaction_confirm'

  get '/terminos', to: 'static#terminos', as: 'terminos'

  get '/estado_referidos', to: 'users#referrals_state', as: 'referral_state'

  devise_for :users, controllers: { registrations: 'registrations', confirmations: 'confirmations', sessions: "sessions" }

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

  get '/my_confirmed_transactions', to: 'admin_dashboard#owner_confirmed_transactions'

  get '/my_canceled_transactions', to: 'admin_dashboard#owner_canceled_transactions'

  get '/donations/:id', to: 'donations#show', as: 'donation_show'

  get '/requests_admin', to: 'admin_dashboard#requests_admin'

  get '/blocked_users', to: 'admin_dashboard#blocked_users'

  get '/requests/:id', to: 'requests#show', as: 'request_show'

  get '/transactions_admin', to: 'admin_dashboard#transactions_admin', as: 'transactions_admin'

  get '/transactions/:id', to: 'transactions#show', as: 'transaction_show'

  post '/unblock_user/:id', to: 'admin_dashboard#unblock_user', as: 'unblock_user'

  post '/restore_balance', to: 'admin_dashboard#restore_receiver_balance', as: 'restore_balance'

  post '/set_as_pending', to: 'admin_dashboard#set_transaction_as_pending', as: 'set_as_pending'

  post '/cancel_transaction', to: 'admin_dashboard#cancel_transaction', as: 'cancel_transaction'

  #Support admin routes
  get  '/admin_chats',to: 'chats#admin_index'

  post  '/admin_messages',to: 'chats#create', as: 'support_messages'

  get  '/support_chats/:chat_id',to: 'messages#admin_index' , as: 'support_chat'

end
