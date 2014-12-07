#!/usr/bin/env ruby

require "./lib/resttestrail/version"
require "./lib/resttestrail/config"
require "./lib/resttestrail/client"
require 'pry'

module Resttestrail
  # Your code goes here...
  Resttestrail.config.host = "testrail-app1.snc1"
  Resttestrail.config.port = 80
  Resttestrail.config.project_id = 26
  Resttestrail.config.username = "bizops-testeng1@groupon.com"
  Resttestrail.config.password = "password"
  suite_id = 1261
  test_case_id = 197611

  puts "host = #{Resttestrail.config.host}, port = #{Resttestrail.config.port}"

  client = Resttestrail::Client.instance
  run_id = client.add_run("an amazing run #{Time.new.strftime("%H_%M_%S_%N")}", suite_id)
  puts "run id = #{run_id}"

  run_test_case_id = client.add_result_for_case(run_id, test_case_id, Resttestrail::Requests::TEST_STATUS_PASSED, 24, nil)
  puts "run test_case_id = #{run_test_case_id}"
end
