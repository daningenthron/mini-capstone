Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/products" => "products#index"
    post "/products" => "products#create"
    get "/products/random" => "products#show_random"
    get "/products/:id" => "products#show"
    patch "/products/:id" => "products#update"
  end
end