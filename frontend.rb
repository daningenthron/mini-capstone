require "unirest"
require "tty-table"

system "clear"

puts "Welcome to World Records!!"
puts "Choose from one of the following options:"
puts "[1] View all available albums"
puts "[2] View an album at random"
puts "[3] Check them out in a table"
puts "[4] Add a new album"
puts "[5] Update an album"

image_hash = {
  "John Coltrane" => "./images/coltrane.jpg", "Led Zeppelin" => "./images/led_zeppelin.jpg", "Pearl Jam" => "./images/pearl_jam.jpg", "Radiohead" => "./images/radiohead.jpg", "The Beatles" => "./images/the_beatles.jpg", "Wilco" => "./images/wilco.jpg"
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
  params = {}
  print "Album artist? "
  params["artist"] = gets.chomp
  print "Album title? "
  params["title"] = gets.chomp
  print "LP or CD? "
  params["media"] = gets.chomp
  print "How much ($)? "
  params["price"] = gets.chomp
  print "URL of the album cover? "
  params["image_url"] = gets.chomp

  response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
  product = response.body
  puts JSON.pretty_generate(product)
elsif input == "5"
  print "Enter an album id: "
  id = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products/#{id}")
  product = response.body
  params = {}
  print "Album artist? (RETURN to leave as #{product["artist"]}) "
  params["artist"] = gets.chomp
  print "Album title? (RETURN to leave as #{product["title"]}) "
  params["title"] = gets.chomp
  print "LP or CD? (RETURN to leave as #{product["media"]}) "
  params["media"] = gets.chomp
  print "How much ($)? (RETURN to leave as #{product["price"]}) "
  params["price"] = gets.chomp
  print "URL of the album cover? (RETURN to leave as #{product["image_url"]}) "
  params["image_url"] = gets.chomp
  params.delete_if { |key, value| value.empty? }

  response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
  product = response.body
  puts JSON.pretty_generate(product)
end