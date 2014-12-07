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

    def get_run(run_id)
      request = Resttestrail::Requests.get_run(run_id)
      Resttestrail::Client.response(@net_http.request(request))
    end

    def delete_run(run_id)
      request = Resttestrail::Requests.delete_run(run_id)
      Resttestrail::Client.response(@net_http.request(request))
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
      response_hash = {:success => false, :code => nil, :body => nil, :message => nil}

      if http_response.nil?
        raise Resttestrail::TestrailError.new(response_hash), "Received nil response"
      end

      response_hash[:success] = (http_response.code == "200" && http_response.message == "OK")
      response_hash[:code] = http_response.code
      response_hash[:body] = http_response.body
      response_hash[:message] = http_response.message

      raise Resttestrail::TestrailError.new(response_hash), "Unsuccessful response" unless response_hash[:success]

      begin
        response_hash[:body] = (http_response.body == "") ? "" : JSON.parse(http_response.body)
        response_hash[:success] = true
      rescue StandardError => e
        response_hash[:success] = false
        raise Resttestrail::TestrailError.new(response_hash), "Error while parsing response"
      end

      response_hash
    end
  end
end
