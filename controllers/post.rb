#post
post("/addcompany") do
  current_company_name = params["company"]
  #Create the company object in the DB
  company = Company.new(
      :name => current_company_name,
      :created_at => Time.now,
      :is_duplicate => false
  )
  #only create the company if it doesn't already exist
  existing_company = Company.first(:name => current_company_name, :deleted => false)
  company.save unless existing_company
  redirect(URI.encode("/#{current_company_name}/addposition"))
end

post("/:company/addposition") do
  current_position_name = params["position"]
  current_company_name = params["company"]

  current_company = Company.first(:name => current_company_name, :deleted => false)

  position = Position.new(
      :name => current_position_name,
      :created_at => Time.now,
      :is_duplicate => false,
      :company_id => current_company.id
  )
  #only create the position if it doesn't already exist for this company
  existing_position = Position.first(:name => current_position_name, :company_id => current_company.id)
  position.save unless existing_position
  redirect(URI.encode("/#{current_company_name}/#{current_position_name}/addsalary"))
end

post("/:company/:position/addsalary") do
  current_position_name = params["position"]
  current_company_name = params["company"]
  current_location = params["location"]
  current_experience = params["experience"]

  salary_amount = params["salary"]

  #get the current company, position, and location objects
  company = Company.first(:name => current_company_name, :deleted => false)
  position = Position.first(:name => current_position_name, :company_id => company.id, :deleted => false)

  if company && position

    #check to see if a salary currently exists
    salary = Salary.first(:name => salary_amount, :position_id => position.id, :location_id => current_location, :experience_level_id => current_experience)

    if salary&.id
      salary.count += 1
      salary.updated_at = Time.now
      salary.save
    else
      salary = Salary.new(
          :name => salary_amount,
          :count => 1,
          :created_at => Time.now,
          :updated_at => Time.now,
          :position_id => position.id,
          :location_id => current_location,
          :experience_level_id => current_experience
      )
    end

    salary.save
  end

  redirect(URI.encode("/#{current_company_name}/#{current_position_name}"))
end