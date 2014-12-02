require 'spec_helper'
require 'json'

describe Resttestrail::Client do

  describe "response" do
    it "raises error for nil http response from testrail" do
      hash_object = {:success => false, :body => nil, :error => nil}
      expect { Resttestrail::Client.response(nil) }.to raise_error { |e|
        expect(e).to be_a(Resttestrail::TestrailError)
        expect(e.message).to eq "Received nil response"
        expect(e.object).to eq hash_object
      }
    end

    it "raises error for nil http response body from testrail" do
      http_response = Net::HTTPResponse.new("1.1", "200", "dummy")
      allow(http_response).to receive_messages(:stream_check => true)
      hash_object = {:success => false, :body => nil, :error => nil}
      expect { Resttestrail::Client.response(http_response) }.to raise_error { |e|
        expect(e).to be_a(Resttestrail::TestrailError)
        expect(e.message).to eq "Received nil response"
        expect(e.object).to eq hash_object
      }
    end

    it "returns the response hash for a successful http response from testrail" do
      http_response = Net::HTTPResponse.new("1.1", "200", "OK")
      body_hash = {"field1" => "value1"}
      hash_object = {:success=>true, :body=>body_hash, :error=>nil}
      allow(http_response).to receive_messages(:stream_check => true, :body => body_hash.to_json)
      expect { Resttestrail::Client.response(http_response) }.not_to raise_error
      response = Resttestrail::Client.response(http_response)
      expect(response).to eq hash_object
    end

    it "raises error for a not ok http response message from testrail" do
      http_response = Net::HTTPResponse.new("1.1", "200", "Not OK")
      body_hash = {"field1" => "value1"}
      hash_object = {:success=>false, :body=>nil, :error=>"Not OK"}
      allow(http_response).to receive_messages(:stream_check => true, :body => body_hash.to_json)
      expect { Resttestrail::Client.response(http_response) }.to raise_error { |e|
        expect(e).to be_a(Resttestrail::TestrailError)
        expect(e.message).to eq "Unsuccessful response"
        expect(e.object).to eq hash_object
      }
    end

    it "raises error for a non 200 http response code from testrail" do
      http_response = Net::HTTPResponse.new("1.1", "201", "OK")
      body_hash = {"field1" => "value1"}
      hash_object = {:success=>false, :body=>nil, :error=>"OK"}
      allow(http_response).to receive_messages(:stream_check => true, :body => body_hash.to_json)
      expect { Resttestrail::Client.response(http_response) }.to raise_error { |e|
        expect(e).to be_a(Resttestrail::TestrailError)
        expect(e.message).to eq "Unsuccessful response"
        expect(e.object).to eq hash_object
      }
    end

    it "raises error for any json parsing errors" do
      http_response = Net::HTTPResponse.new("1.1", "200", "OK")
      body_hash = {}
      hash_object = {:success=>false, :body=>nil, :error=>"OK"}
      allow(http_response).to receive_messages(:stream_check => true, :body => {})
      expect { Resttestrail::Client.response(http_response) }.to raise_error { |e|
        expect(e.message).to eq "Error while parsing response"
        expect(e.object[:error]).to be_a(TypeError)
      }
    end

  end
end
