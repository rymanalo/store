# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
 
 
get '/users' do
  db = SQLite3::Database.new "store.sqlite3"
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM users;').execute
  erb :show_users
end
 
 get '/' do
  erb :home
end

get '/products' do
  db = SQLite3::Database.new "store.sqlite3"
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM products;').execute
  erb :products
end

get '/new-product' do
  erb :new_product
end

post '/new-product' do
  @name = params[:product_name]
  @price = params[:product_price]
  db = SQLite3::Database.new "store.sqlite3"
  sql = "INSERT INTO products ('name', 'price') VALUES('#{@name}', '#{@price}');"
  @rs = db.execute(sql)
  erb :product_created
end

get '/products/:id' do
  db = SQLite3::Database.new "store.sqlite3"
  db.results_as_hash = true
  @id = params[:id]
  @rs = db.prepare("SELECT * FROM products WHERE id = #{@id};").execute
  erb :product_id
end