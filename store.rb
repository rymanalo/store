# gem install --version 1.3.0 sinatra
require 'pry'
# gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'better_errors'
require 'open-uri'
require 'json'
require 'uri'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end
 
before do
  @db = SQLite3::Database.new "store.sqlite3"
  @db.results_as_hash = true
end

 
get '/users' do
  @rs = @db.execute('SELECT * FROM users;')
  erb :show_users
end
 
get '/users.json' do
  @rs = @db.execute('SELECT id, name FROM users;')
  @rs.to_json
end

 get '/' do
  erb :home
end

get '/products' do
  @rs = @db.execute('SELECT * FROM products;')
  erb :products
end

get '/products.json' do
  @rs = @db.execute('SELECT name, on_sale FROM products;')
  @rs.to_json
end

get '/products/search/twitter' do
  @q = params[:q]
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)
  erb :search_results_twitter
end

get '/products/search/google' do
  @q = params[:q]
  file = open("https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyCJO615wXOmLuktUIFAXb14moV7qNvmT4E&country=US&q=#{URI.escape(@q)}&alt=json", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
  @results = JSON.load(file.read)
  erb :search_results_google
end

get '/new-product' do
  erb :new_product
end

post '/new-product' do
  @name = params[:product_name]
  @price = params[:product_price]
  @on_sale = params[:on_sale]
  sql = "INSERT INTO products ('name', 'price', 'on_sale') VALUES('#{@name}', '#{@price}', '#{@on_sale}');"
  @rs = @db.execute(sql)
  erb :product_created
end

get '/products/:id' do
  @id = params[:id]
  @rs = @db.execute("SELECT * FROM products WHERE id = #{@id};")
  erb :product_id
end

get '/products/:id/edit' do
  @id = params[:id]
  sql = "SELECT * FROM products WHERE id = #{@id};"
  row = @db.get_first_row(sql)
  @name = row['name']
  @price = row['price']
  erb :update_product
end

post '/products/:id' do
  @id = params[:id]
  @name = params[:product_name]
  @price = params[:product_price]
  @on_sale = params[:on_sale]
  sql = "UPDATE products SET name = '#{@name}', price = '#{@price}', on_sale = '#{@on_sale}' WHERE id = #{@id};"
  @rs = @db.execute(sql)
  erb :product_updated
end

post '/products/:id/destroy' do
  @id = params[:id]
  sql = "DELETE FROM products WHERE id = #{@id};"
  @rs = @db.execute(sql)
  erb :product_deleted
end