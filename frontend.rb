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
puts "[6] Delete an album"

input = gets.chomp

if input == "1"
  response = Unirest.get("http://localhost:3000/v1/products")
  products = response.body
  products.sort_by { | product | product["id"]}.each { | product | 
   puts JSON.pretty_generate(product)
   image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
   puts `/usr/local/bin/imgcat #{image}`
   }
elsif input == "2"
  response = Unirest.get("http://localhost:3000/v1/products/random")
  product = response.body
  puts JSON.pretty_generate(product)
  image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
  puts `/usr/local/bin/imgcat #{image}`
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
  image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
  `wget --output-document=#{image} #{product["image_url"]}`
  puts JSON.pretty_generate(product)
  puts `/usr/local/bin/imgcat #{image}`
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
  params.delete_if { |_key, value| value.empty? }

  response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
  product = response.body
  puts JSON.pretty_generate(product)
  image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
  puts `/usr/local/bin/imgcat #{image}`
elsif input == "6"
  print "Enter an album id: "
  product_id = gets.chomp
  response = Unirest.delete("http://localhost:3000/v1/products/#{id}")
  body = response.body
  puts JSON.pretty_generate(body)
end