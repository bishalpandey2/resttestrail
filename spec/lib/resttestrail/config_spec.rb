require 'spec_helper'

describe Resttestrail.config do
  it "returns a Resttestrail::Config object" do
    expect(Resttestrail.config).to be_a(Resttestrail::Config)
  end

  it "returns the same config object" do
    config1 = Resttestrail.config
    config2 = Resttestrail.config
    expect(config2).to eq config1
  end
end

describe Resttestrail::Config do
  it "has the right configurations" do
    config = Resttestrail::Config.new
    expect{ config.host }.not_to raise_error
    expect{ config.port }.not_to raise_error
    expect{ config.username }.not_to raise_error
    expect{ config.password }.not_to raise_error
    expect{ config.project_id }.not_to raise_error
  end
end
