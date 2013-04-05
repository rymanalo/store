# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'better_errors'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end
 
before do
  @db = SQLite3::Database.new "store.sqlite3"
  @db.results_as_hash = true
end

 
get '/users' do
  @rs = @db.prepare('SELECT * FROM users;').execute
  erb :show_users
end
 
 get '/' do
  erb :home
end

get '/products' do
  @rs = @db.prepare('SELECT * FROM products;').execute
  erb :products
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
  @rs = @db.prepare("SELECT * FROM products WHERE id = #{@id};").execute
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