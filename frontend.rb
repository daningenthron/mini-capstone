require "unirest"
require "tty-table"

system "clear"

puts "Welcome to World Records!!"
puts "Choose from one of the following options:"
puts "[1] View all available albums"
puts "[2] View an album at random"
puts "[3] Check them out in a table"
puts "[4] Add a new album"

image_hash = {
  "John Coltrane" => "./images/coltrane.jpg", "Led Zeppelin" => "./images/led_zeppelin.jpg", "Pearl Jam" => "./images/pearl_jam.jpg", "Radiohead" => "./images/radiohead.jpg"
  }

input = gets.chomp

if input == "1"
  response = Unirest.get("http://localhost:3000/v1/products")
  products = response.body
  puts JSON.pretty_generate(products)
elsif input == "2"
  response = Unirest.get("http://localhost:3000/v1/products/random")
  product = response.body
  puts JSON.pretty_generate(product)
  image = image_hash[product["artist"]]
  system "imgcat $image"
elsif input == "3"
  response = Unirest.get("http://localhost:3000/v1/products")
  products = response.body
  table = TTY::Table.new [['id','artist','title','media','price']]
  products.each { |product|
    table << [product["id"],product["artist"],product["title"],product["media"],product["price"]] }
  puts table.render(:ascii)
elsif input == "4"
  print "Album artist? "
  input_artist = gets.chomp
  print "Album title? "
  input_title = gets.chomp
  print "LP or CD? "
  input_media = gets.chomp
  print "How much ($)? "
  input_price = gets.chomp
  print "URL of the album cover? "
  input_url = gets.chomp

  params = {
    artist: input_artist, 
    title: input_title, 
    media: input_media, 
    price: input_price, 
    image_url: input_url
  }
  response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
  product = response.body
  puts JSON.pretty_generate(product)
end