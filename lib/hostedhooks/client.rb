module HostedHooks

  class Client

    def initialize(api_key = nil)
      @api_key = api_key || ENV["HOSTEDHOOKS_API_KEY"]
    end

    # Apps

    def list_apps
      get_response("/apps")
    end

    def create_app(uuid, payload = {})
      post_response "/apps", payload.slice(:name)
    end

    def update_app(uuid, payload = {})
      patch_response "/apps/#{uuid}", payload.slice(:name)
    end

    # Subscriptions

    # # Templates
    #
    # def get_template(uid)
    # 	get_response "/templates/#{uid}"
    # end
    #
    # def update_template(uid, payload = {})
    # 	patch_response "/templates/#{uid}", payload.slice(:name, :metadata, :tags)
    # end
    #
    # def list_templates(params = {:page => 1, :tag => nil, :limit => 25, :name => nil})
    # 	get_response "/templates?#{URI.encode_www_form(params.slice(:page, :tag, :limit, :name))}"
    # end
    #
    # # Template Sets
    #
    # def get_template_set(uid)
    # 	get_response "/template_sets/#{uid}"
    # end
    #
    # def list_template_sets(params = {:page => 1})
    # 	get_response "/template_sets?#{URI.encode_www_form(params.slice(:page))}"
    # end




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
