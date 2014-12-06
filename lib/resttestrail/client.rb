require 'net/http'
require 'multi_json'
require './lib/resttestrail/requests'


module Resttestrail
  class Client
    attr_reader :net_http

    private_class_method :new

    def self.instance
      @instance ||= new
    end

    def initialize
      @net_http = Net::HTTP.new(Resttestrail.config.host, Resttestrail.config.port)
    end

    def add_run(run_name, suite_id)
      request = Resttestrail::Requests.add_run(run_name, suite_id)
      http_response = Resttestrail::Client.response(@net_http.request(request))
      http_response[:body]["id"]
    end

    def add_result_for_case(run_id, test_case_id, status, elapsed_time_secs, exception=nil)
      request = Resttestrail::Requests.add_result_for_case(run_id, test_case_id, status, elapsed_time_secs, exception=nil)
      http_response = Resttestrail::Client.response(@net_http.request(request))
      http_response[:body]["id"]
    end

    def self.close_run(run_id)
      request = Resttestrail::Requests.close_run(run_id)
      http_response = Resttestrail::Client.response(@net_http.request(request))
      http_response[:body]["id"]
    end

    def self.response(http_response)
      if (http_response.nil? || http_response.body.nil?)
        raise Resttestrail::TestrailError.new({:success => false, :body => nil, :error => nil}), "Received nil response"
      end

      begin
        success = http_response.code == "200" && http_response.message == "OK"
        body = success ? JSON.parse(http_response.body) : nil
        error = success ? nil : http_response.message
        response_hash = {:success => success, :body => body, :error => error}
      rescue Exception => e
        raise Resttestrail::TestrailError.new({:success => false, :body => http_response.body, :error => e}), "Error while parsing response"
      end

      unless success
        raise Resttestrail::TestrailError.new(response_hash), "Unsuccessful response"
      end

      response_hash
    end
  end
end
