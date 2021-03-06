require 'sidekiq/web'

Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      resources :users
      resources :sessions do
        collection do
          post 'validate'
        end
      end
      resources :circles do
        post 'send_emails'
        post 'generate_monito'
      end
      resources :user_events
    end
  end
end
