class V1::ProductsController < ApplicationController
  
  def display_all_products
    products = Product.all
    render json: products.to_json
  end

  def display_random_product
    index = rand(0..3)
    product = Product.all[index]
    render json: product.to_json
  end

  def display_product
    id = params[:id]
    product = Product.find_by(id: id)
    render json: product.to_json
  end

end
