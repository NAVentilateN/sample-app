Rails.application.routes.draw do
  root "static_pages#home"
  
  get '/help', to: "static_pages#help"
  get '/about', to: "static_pages#about"
  get '/contact', to: "static_pages#contact"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  get '/signup', to: "user#new"
  post 'user/create'
  get 'user/edit'
  patch 'user/update'
  get 'user/all'
  get 'user/show'
  delete 'user/destroy'
end
