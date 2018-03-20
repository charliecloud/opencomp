task :environment do
  require_relative './db/db_connection'
end

namespace :db do
  desc 'migrate changes to your database'
  task :migrate => :environment do
    DBConnection.new('dbconfig.yaml')
  end
end