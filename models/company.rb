class Company
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :is_duplicate, Boolean

  has n, :positions

end
