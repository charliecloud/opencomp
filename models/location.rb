class Location
  include DataMapper::Resource

  property :id, Serial
  property :city, String
  property :state, String
  property :population, Integer
  property :rank, Integer
  property :created_at, DateTime
  property :deleted, Boolean, :default => false

  def to_json
    {
        "id" => @id,
        "city" => @city,
        "state" => @state,
        "population" => @population.to_s,
        "rank" => @rank.to_s,
        "created_at" => @created_at.to_s,
        "deleted" => @deleted.to_s,
    }.to_json
  end
end
