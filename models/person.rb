class Person
  include Neo4j::ActiveNode

  property :name
  property :twitter

  has_many :in, :podcasts, type: :host, model_class: :Podcast
  has_many :in, :guest_podcasts, type: :guest, model_class: :Podcast
end
