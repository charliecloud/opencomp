class Location
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :deleted, Boolean, :default => false

  def to_json
    {
        "id" => @id,
        "name" => @name,
        "created_at" => @created_at.to_s,
        "deleted" => @deleted.to_s,
    }.to_json
  end
end
