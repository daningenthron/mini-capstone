class Category < ApplicationRecord
  has_many :category_products
  has_many :products, through: :category_products

  def product_names
    products.map { |product| product.title }
  end
end
