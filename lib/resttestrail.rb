require "./resttestrail/version"
require "./resttestrail/config"
require "./resttestrail/client"
require 'pry'

module Resttestrail
  # Your code goes here...
  Resttestrail.config.host = "testrail-app1.snc1"
  Resttestrail.config.port = 80
  Resttestrail.config.project_id = 26
  Resttestrail.config.username = "bizops-testeng1@groupon.com"
  Resttestrail.config.password = "password"

  puts "host = #{Resttestrail.config.host}, port = #{Resttestrail.config.port}"

  client = Resttestrail::Client.instance
  run_id = client.add_run("an amazing run #{Time.new.strftime("%H_%M_%S_%N")}", 1261)
  puts "run id = #{run_id}"

end
