Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/all_products" => "products#display_all_products"
    get "/random_product" => "products#display_random_product"
    get "/product/:id" => "products#display_product"
    get "/product" => "products#display_product"
  end
end
