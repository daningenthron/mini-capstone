Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/all_products" => "products#display_all_products"
  get "/random_product" => "products#display_random_product"
end
