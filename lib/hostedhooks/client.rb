module HostedHooks

  class Client

    def initialize(api_key = nil)
      @api_key = api_key || ENV["HOSTEDHOOKS_API_KEY"]
    end

    # Apps

    def list_apps
      get_response("/apps")
    end

    def create_app(payload = {})
      post_response "/apps", payload.slice(:name)
    end

    def update_app(uuid, payload = {})
      patch_response "/apps/#{uuid}", payload.slice(:name)
    end

    # Subscriptions

    def get_subscription(uuid)
      get_response "/subscriptions/#{uuid}"
    end

    def list_subscriptions(app_uuid)
      get_response("/apps/#{app_uuid}/subscriptions")
    end

    def create_subscription(app_uuid, payload = {})
      post_response "/apps/#{app_uuid}/subscriptions", payload.slice(:name)
    end

    # Endpoints

    def get_endpoint(app_uuid, endpoint_uuid)
      get_response "/apps/#{app_uuid}/endpoints/#{endpoint_uuid}"
    end

    def list_endpoints(app_uuid)
      get_response("/apps/#{app_uuid}/endpoints")
    end

    def create_endpoint(subscription_uuid, payload = {})
      post_response "/subscriptions/#{subscription_uuid}/endpoints", payload.slice(:url, :enabled_events, :version, :status, :description)
    end

    def update_endpoint(subscription_uuid, endpoint_uuid, payload = {})
      patch_response "/subscriptions/#{subscription_uuid}/endpoints/#{endpoint_uuid}", payload.slice(:url, :enabled_events, :version, :status, :description)
    end

    # Webhook Events

    def list_webhook_events(app_uuid)
      get_response("/apps/#{app_uuid}/webhook_events")
    end

    # Messages

    def create_app_message(app_uuid, payload = {})
      post_response "/apps/#{app_uuid}/messages", payload.slice(:event_type, :data, :version, :event_id)
    end

    def create_subscription_message(subscription_uuid, payload = {})
      post_response "/subscriptions/#{subscription_uuid}/messages", payload.slice(:event_type, :data, :version, :event_id)
    end

    def create_endpoint_message(subscription_uuid, endpoint_uuid, payload = {})
      post_response "/subscriptions/#{subscription_uuid}/endpoints/#{endpoint_uuid}/messages", payload.slice(:event_type, :data, :version, :event_id)
    end

    private

    HOSTEDHOOKS_API_ENDPOINT = "https://hostedhooks.com/api/v1"

    def get_response(url)
    	response = HTTParty.get("#{HOSTEDHOOKS_API_ENDPOINT}#{url}", timeout: 3, headers: { 'Authorization' => "Bearer #{@api_key}" })
      body = JSON.parse(response.body)
      return {"error" => body['message'], "code" => response.code} if response.code >= 400
      return body
    end

    def post_response(url, payload)
    	response = HTTParty.post("#{HOSTEDHOOKS_API_ENDPOINT}#{url}",
    		body: payload.to_json,
    		timeout: 3,
    		headers: {
    			'Authorization' => "Bearer #{@api_key}",
    			'Content-Type' => 'application/json'
    		}
    	)
      body = JSON.parse(response.body)
    	return {"error" => body['message'], "code" => response.code} if response.code >= 400
    	return body
    end

    def patch_response(url, payload)
    	response = HTTParty.patch("#{HOSTEDHOOKS_API_ENDPOINT}#{url}",
    		body: payload.to_json,
    		timeout: 3,
    		headers: {
    			'Authorization' => "Bearer #{@api_key}",
    			'Content-Type' => 'application/json'
    		}
    	)
      body = JSON.parse(response.body)
      return {"error" => body['message'], "code" => response.code} if response.code >= 400
      return body
    end

  end

end
