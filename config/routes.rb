Rails.application.routes.draw do
  # get 'pages/home'
  root 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users,
              path: '',
              path_names: {
                sign_in: 'login',
                sign_out: 'logout',
                edit: 'profile',
                sign_up: 'registration'},
              controllers: {
                omniauth_callbacks: 'omniauth_callbacks',
                registrations: 'registrations' }
# devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks"}
  resources :users, only: [:show] do
    member do
      post '/verify_phone_number' => 'users#verify_phone_number'
      patch '/update_phone_number' => 'users#update_phone_number'
    end
  end

  resources :rooms, except: [:edit] do
    member do
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'amenities'
      get 'location'
      delete 'delete_attachment'
      get 'preload'
      get 'preview'
    end
    resources :reservations, only: [:create]
    # special method to change price for room booking
    resources :calendars
  end

  resources :guest_reviews, only: [:create, :destroy]
  resources :host_reviews, only: [:create, :destroy]

  get '/your_trips', to: 'reservations#your_trips', as: 'your_trips'
  get '/your_reservations', to: 'reservations#your_reservations', as: 'your_reservations'
  # get '/your_trips' => 'reservations#your_trips'

  get 'search', to: 'pages#search'

   # ====== 2nd phase of the project ======
  get 'dashboard', to: 'dashboards#index'

  resources :reservations, only: [:approve, :decline] do
    member do
      post '/approve', to: 'reservations#approve'
      post '/decline', to: 'reservations#decline'
    end
  end

  get '/host_calendar', to: 'calendars#host', as: 'host_calendar'
  get '/payment_method', to: 'users#payment'
  post '/add_card', to: 'users#add_card'
end

# for devise path: '' -> is not necessary write /users/signup...
# deleted 'user' from controller name and path: 'user/omniauth_callbacks'
# show for user => rest path manage devise
# new route added for deleting image attach => also like: delete :delete_attachment
# your_trips as guest, your_reservations -> visiting my flats
# search action on page controller
# ======================================
# create path /dashboard to get user's profile
# 2 actions for reservation -> on request booking
