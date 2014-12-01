require 'spec_helper'

describe Resttestrail::Requests do
  before(:all) do
    config = Resttestrail.config
    config.username = "some_username"
    config.password = "some_password"
    config.project_id = 37
  end

  it "makes the correct basic auth string" do
    expect(Resttestrail::Requests.basic_auth_string).to eq "Basic c29tZV91c2VybmFtZTpzb21lX3Bhc3N3b3Jk\n"
  end

  it "makes the add run request" do
    add_run_request = Resttestrail::Requests.add_run("an amazing run", 1234)
    expect(add_run_request.method).to eq "POST"
    expect(add_run_request.path).to eq "/index.php?/api/v2/add_run/37"
    expect(add_run_request.body).to eq "{\"suite_id\":1234,\"name\":\"an amazing run\",\"include_all\":true}"
  end
end
