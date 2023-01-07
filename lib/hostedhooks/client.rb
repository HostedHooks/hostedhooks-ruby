module HostedHooks

  class Client

    def initialize(api_key = nil)
      @api_key = api_key || ENV["HOSTEDHOOKS_API_KEY"]
    end

    # Apps

    def list_apps(params = {})
      get_response("/apps", params.slice(:page, :per_page, :offset))
    end

    def create_app(payload = {})
      post_response "/apps", payload.slice(:name)
    end

    def update_app(uuid, payload = {})
      patch_response "/apps/#{uuid}", payload.slice(:name)
    end

    # Subscriptions

    def get_subscription(uuid, params = {})
      get_response("/subscriptions/#{uuid}", params.slice(:page, :per_page, :offset))
    end

    def list_subscriptions(app_uuid, params = {})
      get_response("/apps/#{app_uuid}/subscriptions", params.slice(:page, :per_page, :offset))
    end

    def create_subscription(app_uuid, payload = {})
      post_response "/apps/#{app_uuid}/subscriptions", payload.slice(:name)
    end

    # Endpoints

    def get_endpoint(app_uuid, endpoint_uuid, params = {})
      get_response("/apps/#{app_uuid}/endpoints/#{endpoint_uuid}", params.slice(:page, :per_page, :offset))
    end

    def list_endpoints(app_uuid, params = {})
      get_response("/apps/#{app_uuid}/endpoints", params.slice(:page, :per_page, :offset))
    end

    def create_endpoint(subscription_uuid, payload = {})
      post_response "/subscriptions/#{subscription_uuid}/endpoints", payload.slice(:url, :enabled_events, :version, :status, :description)
    end

    def update_endpoint(subscription_uuid, endpoint_uuid, payload = {})
      patch_response "/subscriptions/#{subscription_uuid}/endpoints/#{endpoint_uuid}", payload.slice(:url, :enabled_events, :version, :status, :description)
    end

    # Webhook Events

    def list_webhook_events(app_uuid, params = {})
      get_response("/apps/#{app_uuid}/webhook_events", params.slice(:page, :per_page, :offset))
    end

    # Messages

    def create_app_message(app_uuid, payload = {})
      post_response "/apps/#{app_uuid}/messages", payload.slice(:event_type, :data, :version, :event_id, :override_payload)
    end

    def create_subscription_message(subscription_uuid, payload = {})
      post_response "/subscriptions/#{subscription_uuid}/messages", payload.slice(:event_type, :data, :version, :event_id, :override_payload)
    end

    def create_endpoint_message(subscription_uuid, endpoint_uuid, payload = {})
      post_response "/subscriptions/#{subscription_uuid}/endpoints/#{endpoint_uuid}/messages", payload.slice(:event_type, :data, :version, :event_id, :override_payload)
    end

    # Webhook Attempts

    def get_webhook_attempt(app_uuid, webhook_attempt_uuid)
      get_response("/apps/#{app_uuid}/webhook_attempts/#{webhook_attempt_uuid}")
    end

    def list_webhook_attempts(app_uuid, params = {})
      get_response("/apps/#{app_uuid}/webhook_attempts", params.slice(:page, :per_page, :offset))
    end

    # HookHelpers

    def list_hook_helpers(params = {})
      get_response("/hook_helpers", params.slice(:page, :per_page, :offset))
    end

    def get_hook_helper(hook_helper_uuid, params = {})
      get_response("/hook_helpers/#{hook_helper_uuid}", params.slice(:page, :per_page, :offset))
    end 

    def create_hook_helper(payload = {})
      post_response "/hook_helpers", payload.slice(:label)
    end 

    def update_hook_helper(hook_helper_uuid, payload = {})
      patch_response "/hook_helpers/#{hook_helper_uuid}", payload.slice(:label, :endpoint_id) 
    end

    private

    HOSTEDHOOKS_API_ENDPOINT = "https://hostedhooks.com/api/v1"

    def get_response(url, params=nil)
      if params
        pagination_query = "?#{params.to_query}"
      end
    	response = HTTParty.get("#{HOSTEDHOOKS_API_ENDPOINT}#{url}#{pagination_query || ''}", timeout: 3, headers: { 'Authorization' => "Bearer #{@api_key}" })
      body = JSON.parse(response.body)
      return {"error" => body['error'], "code" => response.code} if response.code >= 400
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
    	return {"error" => body['error'], "code" => response.code} if response.code >= 400
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
      return {"error" => body['error'], "code" => response.code} if response.code >= 400
      return body
    end

  end

end
