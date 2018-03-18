Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/products" => "products#index"
    post "/products" => "products#create"
    get "/products/random" => "products#show_random"
    get "/products/:id" => "products#show"
    patch "/products/:id" => "products#update"
    delete "/products/:id" => "products#destroy"

    get "/labels" => "labels#index"
    post "/labels" => "labels#create"
    get "/labels/:id" => "labels#show"
    patch "/labels/:id" => "labels#update"
    delete "/labels/:id" => "labels#destroy"
  end
end