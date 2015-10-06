class Podcast
  include Neo4j::ActiveNode

  property :title
  property :url

  has_many :out, :hosts, type: :host
  has_many :out, :guests, type: :guest
end
