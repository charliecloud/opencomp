require 'sinatra'

require_relative 'controllers/routes'
require_relative 'db/dbconfig'

loadDBConfigFile("dbconfig.yaml")
checkAndUpdateDB

