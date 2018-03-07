class ProductsController < ApplicationController
  
  def display_all_products
    products = Product.all
    render json: products.to_json
  end

end
