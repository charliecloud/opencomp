class Position
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :created_at, DateTime
  property :is_duplicate, Boolean, :default => false
  property :deleted, Boolean, :default => false

  belongs_to :company
  has n, :salaries

  def to_json
    {
        "id" => @id,
        "name" => @name,
        "created_at" => @created_at.to_s,
        "is_duplicate" => @is_duplicate.to_s,
        "deleted" => @deleted.to_s
    }.to_json
  end

end
