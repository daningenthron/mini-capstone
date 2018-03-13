class Product < ApplicationRecord
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
      media: media,
      price: price,
      tax: tax,
      total: total,
      is_discounted: is_discounted,
      image_url: image_url,
      created_at: friendly_created_at,
      updated_at: friendly_updated_at
    }
  end
end
