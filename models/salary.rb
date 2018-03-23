class Salary
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :count, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  has 1, :location
  belongs_to :position
end
