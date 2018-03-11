class V1::ProductsController < ApplicationController
  
  def index
    products = Product.all
    render json: products.to_json
  end

  def create
    product = Product.create(artist: params["artist"], title: params["title"], media: params["media"], price: params["price"], image_url: params["image_url"])
    render json: product.to_json
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

  def update
    id = params[:id]
    product = Product.find_by(id: id)
    product.artist = params["artist"] ||  product.artist
    product.title = params["title"] || product.title
    product.media = params["media"] || product.media
    product.price = params["price"] || product.price
    product.image_url = params["image_url"] || product.image_url
    product.save
    render json: product.as_json
  end

  def destroy
    id = params[:id]
    product = Product.find_by(id: id)
    product.destroy
    render json: {message: "Product successfully destroyed."}
  end

end