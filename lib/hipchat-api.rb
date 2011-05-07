require 'httparty'

module HipChat
  class API
    include HTTParty
    
    VERSION = '1.0.0'.freeze
    DEFAULT_TIMEOUT = 3
    
    DEFAULT_HEADERS = {
      'User-Agent' => "HipChat gem #{VERSION}",
    }

    headers(DEFAULT_HEADERS)
    default_timeout(DEFAULT_TIMEOUT)
    format(:json)

    HIPCHAT_API_URL = 'http://api.hipchat.com/v1'

    attr_accessor :hipchat_api_url
    attr_accessor :token
    
    def initialize(token, hipchat_api_url = HIPCHAT_API_URL)
      @token = token
      @hipchat_api_url = hipchat_api_url
    end
    
    def debug(location = $stderr)
      self.class.debug_output(location)
    end

    def set_http_headers(http_headers = {})
      http_headers.merge!(DEFAULT_HEADERS)
      self.class.headers(http_headers)
    end

    def set_timeout(timeout)
      self.class.default_timeout(timeout)
    end

    def rooms_list
      self.class.get(hipchat_api_url_for('rooms/list'), :query => {:auth_token => @token})
    end
    
    def rooms_show(room_id)
      self.class.get(hipchat_api_url_for('rooms/show'), :query => {:auth_token => @token, :room_id => room_id})
    end
    
    private
    
    def hipchat_api_url_for(method)
      "#{@hipchat_api_url}/#{method}"
    end
  end
end