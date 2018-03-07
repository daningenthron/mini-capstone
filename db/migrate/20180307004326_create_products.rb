class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :artist
      t.string :title
      t.string :media
      t.integer :price
      t.string :image_url

      t.timestamps
    end
  end
end
