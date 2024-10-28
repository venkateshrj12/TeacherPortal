Rails.application.routes.draw do
  resources :subjects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  namespace :user do
    resources :login
    resources :accounts do
      collection do
        patch :update
        delete :destroy
      end
    end
  end

  resources :students

  # this route should be at the end to give the error for invalid route
  get '/*a', to: 'application#not_found'
end
