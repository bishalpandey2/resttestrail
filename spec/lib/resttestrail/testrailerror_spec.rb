require 'spec_helper'

describe Resttestrail::TestrailError do
  it "raises the exception with the correct data" do
    message = "Amazing Error"
    hash_object = {:success => false, :body => "body", :error => "error"}
    expect { raise Resttestrail::TestrailError.new(hash_object), message }.to raise_error { |e|
      expect(e).to be_a(Resttestrail::TestrailError)
      expect(e.message).to eq message
      expect(e.object).to eq hash_object
    }
  end
end
