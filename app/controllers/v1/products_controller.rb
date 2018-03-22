class V1::ProductsController < ApplicationController
  before_action :authenticate_admin, except: [:index, :show, :show_random]

  def sort_key
    if params["sort_by"] == "price"
      :price
    else
      :id
    end
  end

  def index
    products = Product.order(sort_key) 
    search_artist = params[:search_artist]
    if search_artist
      products = products.where("artist ILIKE ?", "%#{search_artist}%")
    end
    render json: products.as_json
  end

  def create
    product = Product.new(
      artist: params[:artist], 
      title: params[:title], 
      label: params[:label],
      media: params[:media], 
      price: params[:price], 
      description: params[:description]
      )
    if product.save
      # image = Image.new(url: params[:image_url], product_id: product.id)
      # Image.save
      render json: product.as_json
    else
      render json: {errors: product.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show_random
    index = rand(0..3)
    product = Product.all[index]
    render json: product.as_json
  end

  def show
    id = params[:id]
    product = Product.find_by(id: id)
    render json: product.as_json
  end

  def update
    id = params[:id]
    product = Product.find_by(id: id)
    product.artist = params[:artist] ||  product.artist
    product.title = params[:title] || product.title
    product.media = params[:media] || product.media
    product.price = params[:price] || product.price
    product.description = params[:description] || product.description
    if product.save
      # image = Image.new(url: params[:image_url], product_id: product.id)
      # Image.save      
      render json: product.as_json
    else
      render json: {errors: product.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    id = params[:id]
    product = Product.find_by(id: id)
    product.destroy
    render json: {message: "Product successfully destroyed."}
  end

end