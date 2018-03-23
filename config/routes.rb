Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    post "/carted_products" => "carted_products#create"

    get "/labels" => "labels#index"
    post "/labels" => "labels#create"
    get "/labels/:id" => "labels#show"
    patch "/labels/:id" => "labels#update"
    delete "/labels/:id" => "labels#destroy"

    get "/orders" => "orders#index"
    post "/orders" => "orders#create"
    delete "/orders/:id" => "orders#destroy"

    get "/products" => "products#index"
    post "/products" => "products#create"
    get "/products/random" => "products#show_random"
    get "/products/:id" => "products#show"
    patch "/products/:id" => "products#update"
    delete "/products/:id" => "products#destroy"

    post "/users" => "users#create"
  end
end