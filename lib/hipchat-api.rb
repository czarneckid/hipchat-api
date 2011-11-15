require 'httparty'

module HipChat
  class API
    include HTTParty
    
    VERSION = '1.0.2'
    DEFAULT_TIMEOUT = 3
    
    DEFAULT_HEADERS = {
      'User-Agent' => "HipChat gem #{VERSION}",
    }

    headers(DEFAULT_HEADERS)
    default_timeout(DEFAULT_TIMEOUT)
    format(:json)

    HIPCHAT_API_URL = 'https://api.hipchat.com/v1'

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
    
    # https://www.hipchat.com/docs/api/method/rooms/create
    def rooms_create(name, owner_user_id, privacy = 'public', topic = '', guest_access = 0)
      self.class.post(hipchat_api_url_for('rooms/create'), :body => {:auth_token => @token, :name => name, :owner_user_id => owner_user_id, 
        :topic => topic, :privacy => privacy, :guest_access => guest_access})
    end
    
    # https://www.hipchat.com/docs/api/method/rooms/delete
    def rooms_delete(room_id)
      self.class.post(hipchat_api_url_for('rooms/delete'), :body => {:auth_token => @token, :room_id => room_id})      
    end

    # https://www.hipchat.com/docs/api/method/rooms/history
    def rooms_history(room_id, date, timezone)
      self.class.get(hipchat_api_url_for('rooms/history'), :query => {:auth_token => @token, :room_id => room_id, :date => date, 
        :timezone => timezone})
    end

    # https://www.hipchat.com/docs/api/method/rooms/list
    def rooms_list
      self.class.get(hipchat_api_url_for('rooms/list'), :query => {:auth_token => @token})
    end
    
    # https://www.hipchat.com/docs/api/method/rooms/message
    def rooms_message(room_id, from, message, notify = 0, color = 'yellow')
      self.class.post(hipchat_api_url_for('rooms/message'), :body => {:auth_token => @token, :room_id => room_id, :from => from, 
        :message => message, :notify => notify, :color => color})
    end

    # https://www.hipchat.com/docs/api/method/rooms/show
    def rooms_show(room_id)
      self.class.get(hipchat_api_url_for('rooms/show'), :query => {:auth_token => @token, :room_id => room_id})
    end
            
    # https://www.hipchat.com/docs/api/method/users/create
    def users_create(email, name, title, is_group_admin = 0, password = nil, timezone = 'UTC')
      self.class.post(hipchat_api_url_for('users/create'), :body => {:auth_token => @token, :email => email, :name => name, :title => title, 
        :is_group_admin => is_group_admin, :password => password, :timezone => timezone}.reject!{|key, value| value.nil?})
    end

    # https://www.hipchat.com/docs/api/method/users/delete
    def users_delete(user_id)
      self.class.post(hipchat_api_url_for('users/delete'), :body => {:auth_token => @token, :user_id => user_id})
    end

    # https://www.hipchat.com/docs/api/method/users/list
    def users_list
      self.class.get(hipchat_api_url_for('users/list'), :query => {:auth_token => @token})
    end

    # https://www.hipchat.com/docs/api/method/users/show
    def users_show(user_id)
      self.class.get(hipchat_api_url_for('users/show'), :query => {:auth_token => @token, :user_id => user_id})
    end

    # https://www.hipchat.com/docs/api/method/users/update
    def users_update(user_id, email = nil, name = nil, title = nil, is_group_admin = nil, password = nil, timezone = nil)
      self.class.post(hipchat_api_url_for('users/update'), :body => {:auth_token => @token, :user_id => user_id, :email => email, 
        :name => name, :title => title, :is_group_admin => is_group_admin, :password => password, :timezone => timezone}.reject!{|key, value| value.nil?})
    end
    
    private
    
    def hipchat_api_url_for(method)
      "#{@hipchat_api_url}/#{method}"
    end
  end
end