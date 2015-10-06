class Person
  include Neo4j::ActiveNode

  property :name
  property :twitter

  has_many :in, :podcasts, type: :host
  has_many :in, :guest_episodes, type: :guest, model_class: :Episode
end
