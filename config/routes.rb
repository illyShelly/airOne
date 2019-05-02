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
  resources :users, only: [:show]
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
  end
end

# for devise path: '' -> is not necessary write /users/signup...
# deleted 'user' from controller name and path: 'user/omniauth_callbacks'
# show for user => rest path manage devise
# new route added for deleting image attach => also like: delete :delete_attachment
