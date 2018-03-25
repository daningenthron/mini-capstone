require "unirest"
require "tty-table"
input = ""

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
until input.downcase == "q"
  puts "Your JSON web token is #{jwt}"

  puts "Welcome to World Records!!"
  puts
  puts "Choose from one of the following options: (Q to quit)"
  puts "[1] View all available albums"
  puts "[1.1] Search by price, low to high"
  puts "[1.2] Search by category"
  puts "[2.1] View an album at random"
  puts "[2.2] Search by artist"
  puts "[3] Check them out in a table"
  puts "[4] Add a new album"
  puts "[5] Update an album"
  puts "[6] Delete an album"
  puts "[7] Add item to cart"
  puts "[8] View your cart"
  puts "[10] Checkout"
  puts "[11] View your orders"
  puts "[12] Destroy an order"
  puts
  puts "Or, 'sign up'."

  input = gets.chomp

  if input == "1"
    response = Unirest.get("http://localhost:3000/v1/products")
    products = response.body
    products.each { | product | 
      puts JSON.pretty_generate(product)
      product["image_url"].each { |url| puts `curl -s #{"#{url}"} | imgcat` }
    }
  elsif input == "1.1"
    response = Unirest.get("http://localhost:3000/v1/products?sort_by=price")
    products = response.body
    products.each { | product | 
      puts JSON.pretty_generate(product)
      product["image_url"].each { |url| puts `curl -s #{"#{url}"} | imgcat --width=300` }
    }
  elsif input == "1.2"
    print "Which category would you like to see? "
    input_category = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/products?Category=#{input_category}")
    product = response.body
    puts JSON.pretty_generate(product)
    product["image_url"].each { |url| puts `curl -s #{"#{url}"} | imgcat` }
  elsif input == "2.1"
    response = Unirest.get("http://localhost:3000/v1/products/random")
    product = response.body
    puts JSON.pretty_generate(product)
    product["image_url"].each { |url| puts `curl -s #{"#{url}"} | imgcat` }
  elsif input == "2.2"
    params = {}
    print "Enter artist: "
    params["search_artist"] = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/products", parameters: params)
    products = response.body
    products.each { | product | 
      puts JSON.pretty_generate(product)
      product["image_url"].each { |url| puts `curl -s #{"#{url}"} | imgcat` }
    }
  elsif input == "3"
    response = Unirest.get("http://localhost:3000/v1/products")
    products = response.body
    table = TTY::Table.new [['id','artist','title','label','media','price']]
    products.each { |product|
      table << [product["id"],product["artist"],product["title"],product["label"]["name"],product["media"],product["price"]] }
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
      puts JSON.pretty_generate(product)
      product["image_url"].each { |url| puts `curl -s #{"#{url}"} | imgcat` }
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
      puts JSON.pretty_generate(product)
      product["image_url"].each { |url| puts `curl -s #{"#{url}"} | imgcat` }
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
    response = Unirest.post("http://localhost:3000/v1/carted_products", parameters: params)
    carted_product = response.body
    puts "Added to cart:"
    puts JSON.pretty_generate(carted_product)
  elsif input == "8"
    response = Unirest.get("http://localhost:3000/v1/carted_products")
    carted_products = response.body
    puts "Your cart:"
    puts JSON.pretty_generate(carted_products)
  elsif input == "9"
    print "Enter product id to remove: "
    id = gets.chomp
    response = Unirest.delete("http://localhost:3000/v1/carted_products/#{id}")
    message = response.body
    puts JSON.pretty_generate(message)
  elsif input == "10"
    response = Unirest.post("http://localhost:3000/v1/orders")
    order = response.body
    puts JSON.pretty_generate(order)
  elsif input == "11"
    puts "Here are your orders:"
    response = Unirest.get("http://localhost:3000/v1/orders")
    orders = response.body
    puts JSON.pretty_generate(orders)
  elsif input == "12"
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
end