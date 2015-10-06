class Episode
  include Neo4j::ActiveNode

  property :title
  property :url

  has_one :out, :podcast, type: :episode
  has_many :out, :guests, origin: :person
  has_many :out, :guests, origin: :person
end
