require "test/unit"
require 'yaml'
require_relative('../app')

class TestRoutes < Test::Unit::TestCase
  def testLoadDbConfigFilePass
    text = "username: test \npassword: aaaaa\nhost: localhost\ndatabase: opencomp"

    File.write("dbconfig.yaml", text)
    loadDBConfigFile("dbconfig.yaml")
    assert_empty(4, 3)
  end
end