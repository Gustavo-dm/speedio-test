### Desafio para Vaga Pleno de Ruby on Rails (15 min)

### Cenário

Você foi contratado como desenvolvedor pleno de Ruby on Rails pela empresa fictícia "TechSavvy Solutions". A empresa está desenvolvendo um novo produto, uma plataforma de e-commerce chamada "QuickShop", que está em fase de testes. No entanto, o lançamento está previsto para daqui a duas semanas, e a equipe está sobrecarregada. Sua tarefa é resolver alguns problemas críticos no sistema e implementar uma nova funcionalidade essencial antes do lançamento.

### Parte 1: Correção de Código

Abaixo está um trecho de código que está causando problemas na aplicação. Sua tarefa é identificar e corrigir os problemas, melhorando a eficiência e a clareza do código. Use a biblioteca `SQLite3` para simular o banco de dados.
```ruby 
require 'sqlite3'

# Criação do banco de dados na memória
db = SQLite3::Database.new ":memory:"

# Criação da tabela de produtos
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

# Inserção de alguns produtos para simulação
db.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES ('Product 1', 'Description 1', 10.0, 10, '2023-01-01')"
db.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES ('Product 2', 'Description 2', 20.0, 0, '2023-01-02')"
db.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES ('Product 3', 'Description 3', 30.0, 5, '2023-01-03')"

class ProductsController
  def initialize(db)
    @db = db
  end

  def index(limit)
    products = @db.execute "SELECT * FROM products WHERE stock > #{limit} ORDER BY created_at DESC"
    products.each do |product|
      product[5] = Date.parse(product[5]).strftime("%d-%m-%Y") rescue product[5]
    end
    render json: products
  end

  private

  def render(json:)
    begin
      puts JSON.pretty_generate(json)
    rescue JSON::GeneratorError => e
      puts "Failed to generate JSON: #{e.message}"
    end
  end

  def json
    Class.new do
      def pretty_generate(obj)
        "JSON generation: #{obj.to_s}"
      end
    end.new
  end
end

# Executar a ação index
controller = ProductsController.new(db)
controller.index(0)

db.execute "DELETE FROM products WHERE stock > 5"
controller.index
```

### Parte 2: Desenvolvimento de Funcionalidade

A funcionalidade que precisa ser desenvolvida é uma API para a criação de novos produtos. Os produtos devem ter nome, descrição, preço e quantidade em estoque. A API deve validar os dados de entrada e retornar mensagens de erro apropriadas se os dados não forem válidos.

```ruby
require 'sinatra'
require 'json'

set :port, 4567

# Simulação de banco de dados em memória
DB = SQLite3::Database.new ":memory:"

# Criação da tabela de produtos
DB.execute <<-SQL
  CREATE TABLE products (
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
  data = JSON.parse(request.body.read)

  errors = []
  errors << "Name is required" if data['name'].nil? || data['name'].empty?
  errors << "Description is required" if data['description'].nil? || data['description'].empty?
  errors << "Price is required" if data['price'].nil?
  errors << "Stock is required" if data['stock'].nil?

  if errors.any?
    status 400
    return { errors: errors }.to_json
  end

  DB.execute "INSERT INTO products (name, description, price, stock, created_at) VALUES (?, ?, ?, ?, ?)",
             [data['name'], data['description'], data['price'], data['stock'], Time.now.to_s]

  status 201
  { message: "Product created successfully" }.to_json
end

```

### Parte 3: Role Play e Estratégia

Você tem duas semanas até o lançamento do produto final, e a equipe está composta por três desenvolvedores, incluindo você. A gerência estabeleceu que esta é uma prioridade máxima, mas também há outras tarefas críticas em andamento.

### Situação:

- Você precisa planejar como resolver os problemas e implementar a funcionalidade dentro do prazo.
- Você tem apenas uma semana para resolver os problemas de código e implementar a funcionalidade antes que a equipe de QA inicie os testes finais.

**Bugs Identificados:**

- **Bug A:** Problema de desempenho na busca de produtos.
- **Bug B:** Falha na funcionalidade de carrinho de compras (as vezes o produto não é adicionado).
- **Bug C:** Problemas na API de pagamento.
- **Bug D:** Erro de validação na criação de produtos.
- **Bug E:** Problema de login, onde usuários conseguem ver informações de outras contas.

### Desafio:

1. **Planejamento:** Apresente um plano de ação detalhado sobre como você e sua equipe vão abordar essas tarefas dentro do prazo limitado.
2. **Pensamento Crítico:** Identifique possíveis obstáculos e limitações que podem surgir durante a execução das tarefas e proponha soluções para superá-los.
3. **Inovação:** Pense fora da caixa e sugira pelo menos uma ideia inovadora que poderia ajudar a melhorar a eficiência do trabalho ou a qualidade do produto final.

### Submissão

Durante a chamada ao vivo:

1. Demonstre a correção do código na Parte 1.
2. Implemente e teste a funcionalidade da Parte 2 ao vivo.
3. Apresente e discuta o plano de ação e suas considerações sobre obstáculos e inovações da Parte 3.

Boa sorte!