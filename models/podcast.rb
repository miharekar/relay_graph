class Podcast
  include Neo4j::ActiveNode

  property :title
  property :url

  has_many :out, :hosts, origin: :person
  has_many :in, :episodes, type: :episode
end
