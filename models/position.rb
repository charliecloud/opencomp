class Position
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :is_duplicate, Boolean

  belongs_to :company
  has n, :salarys

  def to_json
    {
        "id" => @id,
        "name" => @name,
        "created_at" => @created_at.to_s,
        "is_duplicate" => @is_duplicate.to_s,
    }.to_json
  end

end
