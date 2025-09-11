require "faraday"
require "json"
require "openssl"

module Momo
  class Configuration
    attr_accessor :api_key, :user_id, :primary_key, :environment, :callback_url

    def initialize
      @environment = Rails.env.production? ? "production" : "sandbox"
      @callback_url = Rails.application.routes.url_helpers.momo_callback_url(host: Rails.application.config.action_mailer.default_url_options[:host])
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # API Base URLs
  def self.base_url
    if configuration.environment == "production"
      "https://momodeveloper.mtn.com"
    else
      "https://sandbox.momodeveloper.mtn.com"
    end
  end

  def self.collection_url
    if configuration.environment == "production"
      "https://momodeveloper.mtn.com/collection"
    else
      "https://sandbox.momodeveloper.mtn.com/collection"
    end
  end
end

# Load configuration from credentials
Rails.application.reloader.to_prepare do
  Momo.configure do |config|
    config.api_key = Rails.application.credentials.momo&.api_key
    config.user_id = Rails.application.credentials.momo&.user_id
    config.primary_key = Rails.application.credentials.momo&.primary_key
  end
end
