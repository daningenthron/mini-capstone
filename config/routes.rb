Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/products" => "products#index"
    get "/products/random" => "products#show_random"
    get "/products/:id" => "products#show"
    post "/products" => "products#create"
  end
end