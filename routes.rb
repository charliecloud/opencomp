require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

require 'yaml'
require 'json'

require_relative 'controllers/get_json'
require_relative 'controllers/get_html'
require_relative 'controllers/post'

require_relative 'models/company'
require_relative 'models/position'
require_relative 'models/salary'
require_relative 'models/location'
require_relative 'models/experience_level'

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


