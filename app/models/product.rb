class Product < ApplicationRecord
  validates :artist, :title, :price, :description, presence: true
  validates :price, numericality: { greater_than: 0.0 }
  validates :description, length: { in: 10..500 }
  validates :title, uniqueness: { scope: [:artist, :media], message: "is already listed!" }

  def friendly_created_at
    created_at.strftime("%m-%e-%y %H:%M")
  end

  def friendly_updated_at
    updated_at.strftime("%m-%e-%y %H:%M")
  end

  def is_discounted
    if media == "LP"
      price < 45
    elsif media == "CD"
      price < 20
    end
  end

  def label
    Label.find_by(id: label_id)["name"]
  end

  def tax
    (price * 0.09).round(2)
  end

  def total
    price + tax
  end

  def as_json
    {
      id: id,
      artist: artist,
      title: title,
      label: label,
      media: media,
      price: price,
      tax: tax,
      total: total,
      is_discounted: is_discounted,
      description: description,
      image_url: image_url,
      created_at: friendly_created_at,
      updated_at: friendly_updated_at
    }
  end
end