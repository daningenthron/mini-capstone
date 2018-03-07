# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create(artist: "John Coltrane", title: "Meditations", media: "LP", price: 30, image_url: "https://www.discogs.com/John-Coltrane-Meditations/release/410594")
Product.create(artist: "Led Zeppelin", title: "Led Zeppelin II", media: "LP", price: 40, image_url: "https://www.discogs.com/Led-Zeppelin-Led-Zeppelin-II/release/3092359")
Product.create(artist: "Pearl Jam", title: "Ten", media: "CD", price: 15, image_url: "https://www.discogs.com/Pearl-Jam-Ten/release/707653")
Product.create(artist: "Radiohead", title: "The Bends", media: "CD", price: 15, image_url: "https://www.discogs.com/Radiohead-The-Bends/master/17008")