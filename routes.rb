require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-migrations/adapters/dm-mysql-adapter'
require 'yaml'
require_relative 'models/company'
require_relative 'models/position'
require_relative 'models/salary'
include ERB::Util

#read db info from config file
dbinfo = YAML.load_file("dbconfig.yaml")

if dbinfo
  username = dbinfo['username']
  password = dbinfo['password']
  host = dbinfo['host']
  database = dbinfo['database']
end

if username && password && host && database
	#initialize the database connection
	DataMapper.setup(:default, "mysql://#{username}:#{password}@#{host}/#{database}")
else
  raise "DB config file dnconfig.yaml does not contain all needed entries"
end

#check the DB models
DataMapper.finalize
#update any db tables as needed
DataMapper.auto_upgrade!

#get
get("/") do
  @title = "Home"
  #Get the latest updated companies using the most recently added salaries
  @companies = repository(:default).adapter.select('select distinct c.id, c.name, s.updated_at from companies c join positions p on
  p.company_id =  c.id join salaries s on
  s.position_id = p.id
	where c.deleted = false
  order by s.updated_at desc
  limit 10;')
  
	erb :index
end

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
  positions = Position.all(:company_id => companies.id, :name.like => "%#{position_name}%")

  positions_array = []
	positions.each do |position|
		positions_array.push(position.to_json)
	end
	puts positions_array
	positions_array.to_json
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
		@company_positions = Position.all(:company_id => @company.id)
	end
	erb :company_profile
end

get("/:company/:position") do
	company_name = params["company"]
	position_name = params["position"]
  @title = "#{position_name} at #{company_name}"
	@company = Company.first(:name => company_name, :deleted => false)

	if @company
		@position = Position.first(:name => position_name, :company_id => @company.id)
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
	salary_amount = params["salary"]

	#get the current company and position objects
	company = Company.first(:name => current_company_name, :deleted => false)
	position = Position.first(:name => current_position_name, :company_id => company.id)

	#check to see if a salary currently exists
	salary = Salary.first(:name => salary_amount, :position_id => position.id)

	if salary && salary.id
		salary.count += 1
    salary.updated_at = Time.now
		salary.save
	else
		salary = Salary.new(
			:name => salary_amount,
			:count => 1,
			:created_at => Time.now,
      :updated_at => Time.now,
			:position_id => position.id
		)
	end

	salary.save

	redirect(URI.encode("/#{current_company_name}/#{current_position_name}"))
end
