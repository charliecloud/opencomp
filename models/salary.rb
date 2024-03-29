class Salary
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :count, Integer, :default => 0
  property :created_at, DateTime
  property :updated_at, DateTime
  property :is_duplicate, Boolean, :default => false
  property :deleted, Boolean, :default => false

  belongs_to :location
  belongs_to :position
  belongs_to :experience_level

end
