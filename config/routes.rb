Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount API => '/'
  get '/docs' => redirect('/swagger-ui/dist/index.html?url=/swagger_docs')

  # login
  get '/login', to: "session#index"
  post '/login', to: "session#session_in"
  get "/logout", to: "session#session_out"
  
  # Register 
  get '/register', to: "register#index"
  post '/register', to: "register#create"
  get '/admin/products', to: "dashboard#home"
  get '/edit/:id', to: "dashboard#edit"
  post "/product", to: "dashboard#update"
  get "/add_product", to: "dashboard#add_product"
end
