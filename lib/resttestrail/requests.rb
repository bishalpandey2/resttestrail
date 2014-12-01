require 'base64'
require 'json'

module Resttestrail

  module Requests
    URI = "/index.php?/api/v2"
    ADD_PLAN = "/add_plan"
    ADD_RUN = "/add_run"

    def self.add_run(run_name, suite_id)
      uri = "#{URI}#{ADD_RUN}/#{Resttestrail.config.project_id}"
      header = {'Content-Type' => 'application/json', 'Authorization' => basic_auth_string}
      request = Net::HTTP::Post.new(uri, initheader = header)
      request.body = {"suite_id" => suite_id, "name" => run_name, "include_all" => true}.to_json
      request
    end

    def self.basic_auth_string
      @basic_auth_string ||= "Basic " + Base64.encode64("#{Resttestrail.config.username}:#{Resttestrail.config.password}")
    end
  end
end
