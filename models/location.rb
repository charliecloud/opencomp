class Location
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :deleted, Boolean, :default => false

  belongs_to :salary
end