class MomoService
  class MomoError < StandardError; end

  def initialize
    @config = Momo.configuration
    @conn = Faraday.new(
      url: Momo.base_url,
      headers: { "Content-Type" => "application/json" }
    )
  end

  # Create API user
  def create_api_user
    response = @conn.post("/v1_0/apiuser") do |req|
      req.headers["X-Reference-Id"] = @config.user_id
      req.headers["Ocp-Apim-Subscription-Key"] = @config.primary_key
      req.body = { providerCallbackHost: @config.callback_url }.to_json
    end

    handle_response(response)
  end

  # Get API key
  def get_api_key
    response = @conn.post("/v1_0/apiuser/#{@config.user_id}/apikey") do |req|
      req.headers["Ocp-Apim-Subscription-Key"] = @config.primary_key
    end

    handle_response(response)
  end

  # Request to pay
  def request_to_pay(transaction_id, amount, currency, payer, message = "Rent payment")
    token = get_access_token

    response = Faraday.new(url: Momo.collection_url).post("/v1_0/requesttopay") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
      req.headers["X-Reference-Id"] = transaction_id
      req.headers["X-Target-Environment"] = @config.environment
      req.headers["Ocp-Apim-Subscription-Key"] = @config.api_key
      req.headers["Content-Type"] = "application/json"

      req.body = {
        amount: amount,
        currency: currency,
        externalId: transaction_id,
        payer: {
          partyIdType: "MSISDN",
          partyId: payer
        },
        payerMessage: message,
        payeeNote: message
      }.to_json
    end

    handle_response(response)
  end

  # Get transaction status
  def get_transaction_status(transaction_id)
    token = get_access_token

    response = Faraday.new(url: Momo.collection_url).get("/v1_0/requesttopay/#{transaction_id}") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
      req.headers["X-Target-Environment"] = @config.environment
      req.headers["Ocp-Apim-Subscription-Key"] = @config.api_key
    end

    handle_response(response)
  end

  private

  def get_access_token
    response = @conn.post("/collection/token/") do |req|
      req.headers["Authorization"] = "Basic #{base64_credentials}"
      req.headers["Ocp-Apim-Subscription-Key"] = @config.api_key
    end

    result = handle_response(response)
    result["access_token"]
  end

  def base64_credentials
    Base64.strict_encode64("#{@config.user_id}:#{@config.api_key}")
  end

  def handle_response(response)
    raise MomoError, "HTTP Error: #{response.status}" unless response.success?

    JSON.parse(response.body) if response.body.present?
  rescue JSON::ParserError
    response.body
  end
end
