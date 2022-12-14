Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'user#home'
  get 'user/login'
  
  resources :user do
    member { get :shopping_list }
  end
  
  resources :products
  get '/admin/products', to: 'products#index'

  resources :shopping_list
  # Defines the root path route ("/")
  # root "articles#index"
end
