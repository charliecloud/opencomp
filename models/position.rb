class Position
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :is_duplicate, Boolean

  belongs_to :company
  has n, :salarys

end