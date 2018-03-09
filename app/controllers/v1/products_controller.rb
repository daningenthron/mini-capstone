class V1::ProductsController < ApplicationController
  
  def index
    products = Product.all
    render json: products.to_json
  end

  def show_random
    index = rand(0..3)
    product = Product.all[index]
    render json: product.to_json
  end

  def show
    id = params[:id]
    product = Product.find_by(id: id)
    render json: product.to_json
  end

  def create
    product = Product.create(artist: params["artist"], title: params["title"], media: params["media"], price: params["price"], image_url: params["image_url"])
    render json: product.to_json
  end

end