require 'sinatra'
require 'json'
require 'sqlite3'

set :port, 4567

# Simulação de banco de dados em memória
DB = SQLite3::Database.new ":memory:"

# Criação da tabela de produtos
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    price REAL,
    stock INTEGER,
    created_at TEXT
  );
SQL

# Endpoint para criar produtos
post '/products' do
  content_type :json
  data = JSON.parse(request.body.read)

  errors = []
  errors << "Name is required" if data['name'].nil? || data['name'].empty?
  errors << "Description is required" if data['description'].nil? || data['description'].empty?
  
  if data['price'].nil? || data['price'].to_s.empty?
    errors << "Price is required"
  elsif !(data['price'].is_a?(Numeric) || (data['price'].is_a?(String) && data['price'].to_f.to_s == data['price']))
    errors << "Price must be a valid number"
  end
  
  errors << "Stock is required" if data['stock'].nil?

  if errors.any?
    status 400
    return { errors: errors }.to_json
  end

  begin
    DB.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES (?, ?, ?, ?, ?)",
               [data['name'], data['description'], data['price'].to_f, data['stock'], Time.now.to_s]
    status 201
    { message: "Product created successfully" }.to_json
  rescue SQLite3::Exception => e
    status 500
    { error: e.message }.to_json
  end
end
