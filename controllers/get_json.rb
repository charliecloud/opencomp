#returns json results for searching companies
get("/search-company") do
  content_type :json

  companies = Company.all(:name.like => "%#{params["company"]}%", :deleted => false)
  companies_array = []

  companies.each do |company|
    companies_array.push(company.to_json)
  end

  companies_array.to_json
end

#returns json results for searching positions
get("/search-position") do
  content_type :json
  company_name = params["company"]
  position_name = params["position"]

  companies = Company.first(:name => "#{company_name}", :deleted => false)
  positions = Position.all(:company_id => companies.id, :name.like => "%#{position_name}%", :deleted => false)

  positions_array = []
  positions.each do |position|
    positions_array.push(position.to_json)
  end

  positions_array.to_json
end

#returns json results for searching locations
get("/search-location") do
  content_type :json
  location_name = params["location"]

  if location_name
    locations = Location.all(:name.like => "%#{location_name}%")
  else
    locations = Location.all()
  end

  locations_array = []
  locations.each do |location|
    locations_array.push(location.to_json)
  end

  return locations_array.to_json
end

get("/search-experience") do
  content_type :json

  experiences = ExperienceLevel.all()

  experiences_array = []
  experiences.each do |experience|
    experiences_array.push(experience.to_json)
  end

  return experiences_array.to_json
end