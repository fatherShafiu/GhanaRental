require "faraday"
require "json"
require "openssl"

module Momo
  class Configuration
    attr_accessor :api_key, :user_id, :primary_key, :environment, :callback_host

    def initialize
      @environment = Rails.env.production? ? "production" : "sandbox"
      @callback_host = Rails.application.config.action_mailer.default_url_options[:host]
    end

    def callback_url
      if callback_host
        Rails.application.routes.url_helpers.momo_callback_url(host: callback_host)
      else
        # Fallback for when routes aren't loaded yet
        "http://localhost:3000/momo/callback"
      end
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
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

# Load configuration from credentials - defer this to when it's actually needed
Momo.configure
