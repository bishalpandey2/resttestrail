require 'base64'
require 'json'

module Resttestrail

  module Requests
    URI = "/index.php?/api/v2"
    ADD_CASE = "/add_case/"
    GET_CASE = "/get_case/"
    DELETE_CASE = "/delete_case/"
    ADD_RUN = "/add_run/"
    GET_RUN = "/get_run/"
    DELETE_RUN = "/delete_run/"
    ADD_RESULT_FOR_CASE = "/add_result_for_case/"
    CLOSE_RUN = "/close_run/"

    TEST_STATUS_PASSED = 1
    TEST_STATUS_FAILED = 5
    TEST_STATUS_BLOCKED = 2

    module Case_Type
      ACCEPTANCE    = 10
      COMPREHENSIVE = 9
      SMOKE         = 8
      SCENARIO      = 7
      OTHER         = 6
      USABILITY     = 5
      REGRESSION    = 4
      PERFORMANCE   = 3
      FUNCTIONALITY = 2
    end

    module Case_Priority
      CRITICAL = 7
      HIGH     = 4
      MEDIUM   = 3
      LOW      = 5
    end

    def self.add_case(section_id, title, type_id, priority_id, estimate, milestone_id, refs)
      uri = "#{URI}#{ADD_CASE}#{section_id}"
      request = Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
      body = {"title" => title, "type_id" => type_id, "priority_id" => priority_id}
      body.merge!("estimate" => estimate) if (!estimate.nil? && estimate.is_a?(String))
      body.merge!("milestone_id" => milestone_id) if (!milestone_id.nil? && milestone_id.is_a?(Integer))
      body.merge!("refs" => refs) if (!refs.nil? && refs.is_a?(String))
      request.body = body.to_json
      request
    end

    def self.get_case(case_id)
      Net::HTTP::Get.new("#{URI}#{GET_CASE}#{case_id}", initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
    end

    def self.delete_case(case_id)
      Net::HTTP::Post.new("#{URI}#{DELETE_CASE}#{case_id}", initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
    end

    def self.add_run(run_name, suite_id)
      uri = "#{URI}#{ADD_RUN}#{Resttestrail.config.project_id}"
      request = Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
      request.body = {"suite_id" => suite_id, "name" => run_name, "include_all" => true}.to_json
      request
    end

    def self.get_run(run_id)
      Net::HTTP::Get.new("#{URI}#{GET_RUN}#{run_id}", initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
    end

    def self.delete_run(run_id)
      Net::HTTP::Post.new("#{URI}#{DELETE_RUN}#{run_id}", initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
    end

    def self.add_result_for_case(run_id, test_case_id, status, elapsed_time_secs, comment=nil, defects=nil)
      uri = "#{URI}#{ADD_RESULT_FOR_CASE}#{run_id}/#{test_case_id}"
      request = Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
      body = {"status_id" => status}
      unless elapsed_time_secs.nil?
        elapsed_time_secs = 1 if elapsed_time_secs < 1
        elapsed_time = elapsed_time_secs.round.to_s+"s"
        body.merge!("elapsed" => elapsed_time)
      end
      body.merge!("comment" => comment) if (!comment.nil? && comment.is_a?(String))
      body.merge!("defects" => defects[0...250]) if (!defects.nil? && defects.is_a?(String))
      request.body = body.to_json
      request
    end

    def self.close_run(run_id)
      uri = "#{URI}#{CLOSE_RUN}#{run_id}"
      Net::HTTP::Post.new(uri, initheader = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string})
    end

    def self.basic_auth_string
      @@basic_auth_string ||= "Basic " + Base64.encode64("#{Resttestrail.config.username}:#{Resttestrail.config.password}")
    end
  end
end
