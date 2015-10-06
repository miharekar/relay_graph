$LOAD_PATH.unshift(*['.', 'models/'])
require 'bundler'
Bundler.require
Dotenv.load

auth = {username: ENV['NEO4J_USERNAME'], password: ENV['NEO4J_PASSWORD']}
Neo4j::Session.open(:server_db, 'http://localhost:7474', basic_auth: auth)

require 'importer'
importer = Importer.new
importer.import
