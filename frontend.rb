require "unirest"
require "tty-table"

system "clear"

puts "Welcome to World Records!!"
puts "Choose from one of the following options:"
puts "[1] View all available albums"
puts "[2] View an album at random"
puts "[3] Check them out in a table"

input = gets.chomp

if input == "1"
  response = Unirest.get("http://localhost:3000/v1/all_products")
  products = response.body
  puts JSON.pretty_generate(products)
elsif input == "2"
  response = Unirest.get("http://localhost:3000/v1/random_product")
  product = response.body
  puts JSON.pretty_generate(product)
elsif input == "3"
  response = Unirest.get("http://localhost:3000/v1/all_products")
  products = response.body
  table = TTY::Table.new [['id','artist','title','media','price']]
  products.each { |product|
    table << [product["id"],product["artist"],product["title"],product["media"],product["price"]] }
  puts table.render(:ascii)
end