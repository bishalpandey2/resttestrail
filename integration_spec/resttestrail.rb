#!/usr/bin/env ruby

require "./lib/resttestrail/version"
require "./lib/resttestrail/testrailerror"
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

  begin
    client = Resttestrail::Client.instance

    new_test_case_id = client.add_case(72621, "a new test case - delete me",
                                    Resttestrail::Requests::Case_Type::FUNCTIONALITY,
                                    Resttestrail::Requests::Case_Priority::MEDIUM,
                                    estimate="1m 14s", milestone_id=nil, refs="REF1 REF2")
    puts client.get_case(new_test_case_id)
    client.delete_case(new_test_case_id)

    run_id = client.add_run("an amazing run #{Time.new.strftime("%H_%M_%S_%N")}", suite_id)
    puts "run id = #{run_id}"

    run_test_case_id = client.add_result_for_case(run_id, test_case_id, Resttestrail::Requests::TEST_STATUS_PASSED, 24, nil)
    puts "new test_case_id = #{run_test_case_id}"

    new_run = client.get_run(run_id)
    puts "run data= #{new_run}"

    client.delete_run(run_id)
    puts "run deleted"

    puts "Finished!!"
  rescue TestrailError => e
    puts "Exception:"
    puts "Message = #{e.message}"
    puts "Hash = #{e.object}"
  end
end
