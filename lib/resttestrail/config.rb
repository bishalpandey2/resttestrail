require 'active_support/configurable'

module Resttestrail

  def self.config
    @config ||= Config.new
  end

  class Config
    include ActiveSupport::Configurable
    config_accessor :host, :port, :username, :password, :project_id
  end
end
