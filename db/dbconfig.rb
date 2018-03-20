require 'dm-core'
require 'dm-migrations'
require 'dm-migrations/adapters/dm-mysql-adapter'
require 'yaml'

def checkAndUpdateDB
  #check the DB models
  DataMapper.finalize
  #update any db tables as needed
  DataMapper.auto_upgrade!
end

def loadDBConfigFile(filename)
  #read db info from config file
  dbinfo = YAML.load_file(filename)

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

  def readFromYAMLFile
    
  end
end