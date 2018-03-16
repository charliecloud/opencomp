require "json"
class Company
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :created_at, DateTime
  property :is_duplicate, Boolean

  has n, :positions

  def to_json
    {
        "json_class" => self.class.name,
        "data" => {
          "id" => @id,
          "name" => @name,
          "created_at" => @created_at,
          "is_duplicate" => @is_duplicate,
        }
    }
  end

end
