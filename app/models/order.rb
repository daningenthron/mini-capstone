class Order < ApplicationRecord

  belongs_to :user

  has_many :carted_products
  has_many :products, through: :carted_products

  def update_all_totals
    calculated_subtotal = 0
    carted_products.each { |cp| calculated_subtotal += cp.product.price * cp.quantity }
    calculated_tax = calculated_subtotal * 0.09
    calculated_total = calculated_subtotal + calculated_tax

    self.subtotal = calculated_subtotal
    self.tax = calculated_tax
    self.total = calculated_total
    self.save
  end

end
