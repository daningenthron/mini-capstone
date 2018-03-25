class V1::OrdersController < ApplicationController
  before_action :authenticate_user

  def create
    carted_products = current_user.carted_products.where(status: "carted")

    subtotal = 0
    carted_products.each { |cp| subtotal += cp.product.price * cp.quantity }
    tax = subtotal * 0.09
    total = subtotal + tax

    order = Order.new(
      user_id: current_user.id,
      subtotal: subtotal,
      tax: tax,
      total: total
      )
    if order.save
      carted_products.update_all(status: "purchased", order_id: order.id)
      render json: order.as_json
    else
      render json: {errors: order.errors.full_messages}, status: 422
    end
  end

  def index
    if current_user
      orders = current_user.orders.order(:id)
      render json: orders.as_json
    else
      render json: []
    end
  end

  def destroy
    id = params[:id]
    order = Order.find_by(id: id)
    order.destroy
    render json: {message: "Order successfully destroyed."}
  end

end