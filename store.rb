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