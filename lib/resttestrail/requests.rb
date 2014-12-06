require 'base64'
require 'json'

module Resttestrail

  module Requests
    URI = "/index.php?/api/v2"
    ADD_PLAN = "/add_plan"
    ADD_RUN = "/add_run"
    ADD_RESULT_FOR_CASE = "/add_result_for_case"
    CLOSE_RUN = "/close_run"

    TEST_STATUS_PASSED = 1
    TEST_STATUS_FAILED = 5
    TEST_STATUS_BLOCKED = 2

    def self.add_run(run_name, suite_id)
      uri = "#{URI}#{ADD_RUN}/#{Resttestrail.config.project_id}"
      request = Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
      request.body = {"suite_id" => suite_id, "name" => run_name, "include_all" => true}.to_json
      request
    end

    def self.add_result_for_case(run_id, test_case_id, status, elapsed_time_secs, exception=nil)
      uri = "#{URI}#{ADD_RESULT_FOR_CASE}/#{run_id}/#{test_case_id}"
      request = Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
      body = {"status_id" => status}
      unless elapsed_time_secs.nil?
        elapsed_time_secs = 1 if elapsed_time_secs < 1
        elapsed_time = elapsed_time_secs.round.to_s+"s"
        body.merge!("elapsed" => elapsed_time)
      end
      body.merge!("defects" => exception) unless exception.nil?
      request.body = body.to_json
      request
    end

    def self.close_run(run_id)
      uri = "#{URI}#{CLOSE_RUN}/#{run_id}"
      Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
    end

    def self.basic_auth_string
      @@basic_auth_string ||= "Basic " + Base64.encode64("#{Resttestrail.config.username}:#{Resttestrail.config.password}")
    end
  end
end
