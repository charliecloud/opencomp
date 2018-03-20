require 'dm-core'
require 'dm-migrations'
require 'yaml'

class DBConnection
  def initialize(filename)
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

    #check the DB models
    DataMapper.finalize
  end

  def initDBTables
    DataMapper.auto_migrate!
  end

  def upgradeDBTables
    #update any db tables as needed
    DataMapper.auto_upgrade!
  end
end