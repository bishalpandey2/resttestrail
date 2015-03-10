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

  it "makes the add result for case request for passed test" do
    add_result_for_case_request = Resttestrail::Requests.add_result_for_case(1234, 45, Resttestrail::Requests::TEST_STATUS_PASSED, 37, nil)
    expect(add_result_for_case_request.method).to eq "POST"
    expect(add_result_for_case_request.path).to eq "/index.php?/api/v2/add_result_for_case/1234/45"
    expect(add_result_for_case_request.body).to eq "{\"status_id\":1,\"elapsed\":\"37s\"}"
  end

  it "makes the add result for case request for failed test with some comments" do
    add_result_for_case_request = Resttestrail::Requests.add_result_for_case(1234, 45, Resttestrail::Requests::TEST_STATUS_FAILED, 37, "some comments")
    expect(add_result_for_case_request.method).to eq "POST"
    expect(add_result_for_case_request.path).to eq "/index.php?/api/v2/add_result_for_case/1234/45"
    expect(add_result_for_case_request.body).to eq "{\"status_id\":5,\"elapsed\":\"37s\",\"comment\":\"some comments\"}"
    expect(add_result_for_case_request.body["defects"]).to be_nil
  end

  it "makes the add result for case request for failed test with some defects" do
    add_result_for_case_request = Resttestrail::Requests.add_result_for_case(1234, 45, Resttestrail::Requests::TEST_STATUS_FAILED, 37, nil, "some defects")
    expect(add_result_for_case_request.method).to eq "POST"
    expect(add_result_for_case_request.path).to eq "/index.php?/api/v2/add_result_for_case/1234/45"
    body = JSON.parse(add_result_for_case_request.body)
    expect(body["status_id"]).to eq 5
    expect(body["elapsed"]).to eq "37s"
    expect(body["comment"]).to be_nil
    expect(body["defects"]).to eq "some defects"
  end

  it "makes the add result for case request for failed test with defects which is not string" do
    add_result_for_case_request = Resttestrail::Requests.add_result_for_case(1234, 45, Resttestrail::Requests::TEST_STATUS_FAILED, 37, "some comments", 1234)
    expect(add_result_for_case_request.method).to eq "POST"
    expect(add_result_for_case_request.path).to eq "/index.php?/api/v2/add_result_for_case/1234/45"
    body = JSON.parse(add_result_for_case_request.body)
    expect(body["status_id"]).to eq 5
    expect(body["elapsed"]).to eq "37s"
    expect(body["comment"]).to eq "some comments"
    expect(body["defects"]).to be_nil
  end

  it "makes the add result for case request for failed test with defects which is longer than 250 chars" do
    add_result_for_case_request = Resttestrail::Requests.add_result_for_case(1234, 45, Resttestrail::Requests::TEST_STATUS_FAILED, 37, "some comments", "a"*300)
    expect(add_result_for_case_request.method).to eq "POST"
    expect(add_result_for_case_request.path).to eq "/index.php?/api/v2/add_result_for_case/1234/45"
    body = JSON.parse(add_result_for_case_request.body)
    expect(body["status_id"]).to eq 5
    expect(body["elapsed"]).to eq "37s"
    expect(body["comment"]).to eq "some comments"
    expect(body["defects"]).to eq "a"*250
  end

  it "makes the close run request" do
    close_run_request = Resttestrail::Requests.close_run(1234)
    expect(close_run_request.method).to eq "POST"
    expect(close_run_request.path).to eq "/index.php?/api/v2/close_run/1234"
    expect(close_run_request.body).to eq nil
  end

  it "makes the get run request" do
    get_run_request = Resttestrail::Requests.get_run(1234)
    expect(get_run_request.method).to eq "GET"
    expect(get_run_request.path).to eq "/index.php?/api/v2/get_run/1234"
    expect(get_run_request.body).to eq nil
  end

  it "makes the delete run request" do
    delete_run_request = Resttestrail::Requests.delete_run(1234)
    expect(delete_run_request.method).to eq "POST"
    expect(delete_run_request.path).to eq "/index.php?/api/v2/delete_run/1234"
    expect(delete_run_request.body).to eq nil
  end
end
