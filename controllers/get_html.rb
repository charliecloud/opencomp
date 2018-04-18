get("/") do
  @title = "Home"
  @updates = Salary.all(:deleted => false, :limit => 10)

  erb :index
end

get("/addcompany") do
  @title = "Add Company"
  erb :add_company
end

get("/companies") do
  @title = "Companies"
  @companies = Company.all(:deleted => false)
  erb :companies
end

get("/positions") do
  @title = "Positions"
  #Get all of the distinct positions
  @positions = repository(:default).adapter.select('SELECT DISTINCT name FROM positions WHERE deleted=0')
  erb :positions
end

get("/position/:position") do
  #First check to make sure it is a valid position
  @position = Position.first(:name => params["position"])
  if @position
    @title = "All companies with #{@position.name}"
    #Get all company names with this position
    @companies = Company.all(Company.positions.name => @position.name)
  end
  erb :companies_by_position
end

get("/:company/addposition") do
  @company = params["company"]
  @title = "Add Position to #{@company}"
  erb :add_position
end

get("/:company") do
  company_name = params["company"]
  @title = company_name
  @company = Company.first(:name => company_name, :deleted => false)
  if @company
    @company_positions = Position.all(:company_id => @company.id, :deleted => false)
  end
  erb :company_profile
end

get("/:company/:position") do
  company_name = params["company"]
  position_name = params["position"]
  @title = "#{position_name} at #{company_name}"
  @company = Company.first(:name => company_name, :deleted => false)

  if @company
    @position = Position.first(:name => position_name, :company_id => @company.id, :deleted => false)
  end

  if @position
    @salaries = Salary.all(:position_id => @position.id)
  end

  erb :position_profile
end

get ("/:company/:position/addsalary") do
  @company = params["company"]
  @position = params["position"]
  @title = "Add salary for #{@position} at #{@company}"
  erb :add_salary
end