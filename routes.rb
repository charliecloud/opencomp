require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-migrations/adapters/dm-mysql-adapter'
require_relative 'models/company'
require_relative 'models/position'
require_relative 'models/salary'

DataMapper.setup(:default, 'mysql://root:sadcow210@localhost/opencomp')
#init the tables
DataMapper.finalize
# DataMapper.auto_migrate!
DataMapper.auto_upgrade!


# def add_key_value_to_hash(hash, key, value)
# 	hash[key] = value unless hash.include?(key)
# end
#
# def add_object_to_array(object, array)
# 	array.push(object) unless array.include?(object)
# end
#
# def add_salary_or_increment(hash, key)
# 	if hash.include?(key)
# 		hash[key] += 1
# 	else
# 		hash[key] = 1
# 	end
# end

#get
get("/") do
	#get all of the Companies
	@companies = Company.all
	erb :index
end

get("/addcompany") do
	erb :add_company
end

get("/companies") do
	@companies = Company.all
	erb :companies
end

get("/:company/addposition") do
	@company = params["company"]
	erb :add_position
end

get("/:company") do
	company_name = params["company"]
	@company = Company.first(:name => company_name)
	if @company
		@company_positions = Position.all(:company_id => @company.id)
	end
	erb :company_profile
end

get("/:company/:position") do
	company_name = params["company"]
	position_name = params["position"]

	@company = Company.first(:name => company_name)

	if @company
		@position = Position.first(:name => position_name, :company_id => @company.id)
	end

	if @position
		@salaries = Salary.all(:position_id => @position.id)
	end
	#Get the salaries
	#@salaries = @companies[@company_name][@position]
	erb :position_profile
end

get ("/:company/:position/addsalary") do
	@company = params["company"]
	@position = params["position"]
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
	#check to see if the company exists
	# add_key_value_to_hash(@companies, current_company, {})
	company.save
	redirect(URI.encode("/#{current_company_name}/addposition"))
end

post("/:company/addposition") do
	current_position_name = params["position"]
	current_company_name = params["company"]
	# company = @companies[params["company"]]
	# add_key_value_to_hash(company, current_position, {})
	position = Position.new(
		:name => current_position_name,
		:created_at => Time.now,
		:is_duplicate => false,
		:company_id => Company.first(:name => current_company_name).id
	)
	position.save
	redirect(URI.encode("/#{current_company_name}/#{current_position_name}/addsalary"))
end

post("/:company/:position/addsalary") do
	current_position_name = params["position"]
	current_company_name = params["company"]
	salary_amount = params["salary"]

	#get the current company and position objects
	company = Company.first(:name => current_company_name)
	position = Position.first(:name => current_position_name, :company_id => company.id)

	#check to see if a salary currently exists
	salary = Salary.first(:name => salary_amount, :position_id => position.id)
	puts salary

	if salary && salary.id
		salary.count += 1
		salary.save
	else
		salary = Salary.new(
			:name => salary_amount,
			:count => 1,
			:created_at => Time.now,
			:position_id => position.id
		)
	end

	salary.save
	# company = @companies[params["company"]]
	# position_hash = company[current_position]

	# add_salary_or_increment(position_hash, salary)
	redirect("/")
end
