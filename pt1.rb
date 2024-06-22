require 'sqlite3'
require 'json'

# Criação do banco de dados na memória
db = SQLite3::Database.new ":memory:"

# Criação da tabela de produtos com índices para melhorar a performance das consultas
db.execute <<-SQL
  CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    price REAL,
    stock INTEGER,
    created_at TEXT
  );
SQL

db.execute <<-SQL
  CREATE INDEX idx_products_stock_created_at ON products (stock, created_at);
SQL

# Inserção de alguns produtos para simulação
db.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES ('Product 1', 'Description 1', 10.0, 10, '2023-01-01')"
db.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES ('Product 2', 'Description 2', 20.0, 0, '2023-01-02')"
db.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES ('Product 3', 'Description 3', 30.0, 5, '2023-01-03')"

class ProductsController
  def initialize(db)
    @db = db
    #Prepare statement, ref : https://medium.com/@devinburnette/be-prepared-7768d1a111e1
    @index_statement = @db.prepare "SELECT * FROM products WHERE stock > 0 ORDER BY created_at DESC"
  end

  def index
    products = @index_statement.execute.to_a
    render json: products
  end

  private

  def render(json:)
    puts JSON.pretty_generate(json)
  end
end

# Executar a ação index
controller = ProductsController.new(db)
controller.index
