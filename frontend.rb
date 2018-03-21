require "unirest"
require "tty-table"

puts "Log in!"
print "Email: "
email = "bob@email.com"
print "Password: "
password = "password"
response = Unirest.post("http://localhost:3000/user_token", 
  parameters: {
    auth: {
      email: email,
      password: password
    }
  }
)
jwt = response.body["jwt"]
Unirest.default_header("Authorization", "Bearer #{jwt}")

system "clear"
puts "Your JSON web token is #{jwt}"

puts "Welcome to World Records!!"
puts
puts "Choose from one of the following options:"
puts "[1] View all available albums"
puts "[1.1] Search by price, low to high"
puts "[2.1] View an album at random"
puts "[2.2] Search by artist"
puts "[3] Check them out in a table"
puts "[4] Add a new album"
puts "[5] Update an album"
puts "[6] Delete an album"
puts "[7] Buy an album"
puts "[8] View your orders"
puts "[9] Destroy an order"
puts
puts "Or, 'sign up'."

input = gets.chomp

if input == "1"
  response = Unirest.get("http://localhost:3000/v1/products")
  products = response.body
  products.each { | product | 
    puts JSON.pretty_generate(product)
    image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
    puts `/usr/local/bin/imgcat #{image}`
  }
elsif input == "1.1"
  response = Unirest.get("http://localhost:3000/v1/products?sort_by=price")
  products = response.body
  products.each { | product | 
    puts JSON.pretty_generate(product)
    image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
    puts `/usr/local/bin/imgcat #{image}`
  }
elsif input == "2.1"
  response = Unirest.get("http://localhost:3000/v1/products/random")
  product = response.body
  puts JSON.pretty_generate(product)
  image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
  puts `/usr/local/bin/imgcat #{image}`
elsif input == "2.2"
  params = {}
  print "Enter artist: "
  params["search_artist"] = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products", parameters: params)
  products = response.body
  products.each { | product | 
    puts JSON.pretty_generate(product)
    image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
    puts `/usr/local/bin/imgcat #{image}`
  }
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
  print "Description? "
  params["description"] = gets.chomp
  print "URL of the album cover? "
  params["image_url"] = gets.chomp

  response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
  product = response.body
  if product["errors"]
    puts "Uh oh! Something went wrong..."
    p product["errors"]
  else
    image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
    `wget --output-document=#{image} #{product["image_url"]}`
    puts JSON.pretty_generate(product)
    puts `/usr/local/bin/imgcat #{image}`
  end
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
  print "Description? (RETURN to leave as #{product["description"]}) "
  params["description"] = gets.chomp
  params.delete_if { |_key, value| value.empty? }

  response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
  product = response.body
  if product["errors"]
    puts "Uh oh! Something went wrong..."
    p product["errors"]
  else
    image = "./images/" + product["artist"].gsub(" ","_").downcase + ".jpg"
    `wget --output-document=#{image} #{product["image_url"]}`
    puts JSON.pretty_generate(product)
    puts `/usr/local/bin/imgcat #{image}`
  end
elsif input == "6"
  print "Enter an album id: "
  product_id = gets.chomp
  response = Unirest.delete("http://localhost:3000/v1/products/#{id}")
  body = response.body
  puts JSON.pretty_generate(body)
elsif input == "7"
  params = {}
  print "Product Id: "
  params["product_id"] = gets.chomp
  print "Quantity: "
  params["quantity"] = gets.chomp 
  response = Unirest.post("http://localhost:3000/v1/orders", parameters: params)
  p response.body
elsif input == "8"
  puts "Here are your orders:"
  response = Unirest.get("http://localhost:3000/v1/orders")
  orders = response.body
  puts JSON.pretty_generate(orders)
elsif input == "9"
  puts "Order id? "
  id = gets.chomp
  response = Unirest.delete("http://localhost:3000/v1/orders/#{id}")
  body = response.body
  puts JSON.pretty_generate(body)

elsif ["sign up", "signup", "'sign up'", "'signup'"].include? input.downcase
  params = {}
  print "Name: "
  params["name"] = gets.chomp
  print "Email: "
  params["email"] = gets.chomp
  print "Password: "
  params["password"] = gets.chomp
  print "Confirm password: "
  params["password_confirmation"] = gets.chomp

  response = Unirest.post("http://localhost:3000/v1/users", parameters: params)
  order = response.body
  puts JSON.pretty_generate(order)
end