require "unirest"

system "clear"

puts "Welcome to World Records!!"
puts "Choose from one of the following options:"
puts "[1] View all available albums"
puts "[2] View an album at random"

input = gets.chomp

if input == "1"
  response = Unirest.get("http://localhost:3000/all_products")
  products = response.body
  puts JSON.pretty_generate(products)
elsif input == "2"
  response = Unirest.get("http://localhost:3000/random_product")
  product = response.body
  puts JSON.pretty_generate(product)
end