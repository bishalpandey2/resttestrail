require 'spec_helper'

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
      hash_object = {:success => false, :body => nil, :error => nil}
      expect { Resttestrail::Client.response(nil) }.to raise_error { |e|
        expect(e).to be_a(Resttestrail::TestrailError)
        expect(e.message).to eq "Received nil response"
        expect(e.object).to eq hash_object
      }
    end
  end
end
