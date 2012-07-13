require 'httparty'
require 'hipchat-api/version'

module HipChat
  class API
    include HTTParty
    
    # Default timeout of 3 seconds
    DEFAULT_TIMEOUT = 3
    
    # Default headers for HTTP requests
    DEFAULT_HEADERS = {
      'User-Agent' => "HipChat gem #{VERSION}",
    }

    # HipChat API URL
    HIPCHAT_API_URL = 'https://api.hipchat.com/v1'

    headers(DEFAULT_HEADERS)
    default_timeout(DEFAULT_TIMEOUT)
    format(:json)

    # HipChat API URL
    attr_accessor :hipchat_api_url

    # HipChat access token
    attr_accessor :token
    
    # Create a new instance of the +HipChat::API+ for interacting with HipChat
    #
    # @param token [String] HipChat access token
    # @param hipchat_api_url [String] HipChat API URL
    def initialize(token, hipchat_api_url = HIPCHAT_API_URL)
      @token = token
      @hipchat_api_url = hipchat_api_url
    end
    
    # Turn on HTTParty debugging
    # 
    # @param location [Object] Output "sink" for HTTP debugging
    def debug(location = $stderr)
      self.class.debug_output(location)
    end

    # Set new HTTP headers for requests
    # 
    # @param http_headers [Hash] HTTP headers
    def set_http_headers(http_headers = {})
      http_headers.merge!(DEFAULT_HEADERS)
      self.class.headers(http_headers)
    end

    # Set new HTTP timeout for requests
    #
    # @param timeout [int] Timeout in seconds
    def set_timeout(timeout)
      self.class.default_timeout(timeout)
    end
    
    # Creates a new room.
    # 
    # @param name [String] Name of the room.
    # @param owner_user_id [int] User ID of the room's owner.
    # @param privacy [String, 'public'] Privacy setting for room.
    # @param topic [String, ''] Room topic.
    # @param guest_access [int, 0] Whether or not to enable guest access for this room. 0 = false, 1 = true. (default: 0).
    #
    # @see https://www.hipchat.com/docs/api/method/rooms/create  
    def rooms_create(name, owner_user_id, privacy = 'public', topic = '', guest_access = 0)
      self.class.post(hipchat_api_url_for('rooms/create'), :body => {:auth_token => @token, :name => name, :owner_user_id => owner_user_id, 
        :topic => topic, :privacy => privacy, :guest_access => guest_access})
    end
    
    # Deletes a room and kicks the current participants. 
    # 
    # @param room_id [int] ID of the room
    #
    # @see https://www.hipchat.com/docs/api/method/rooms/delete
    def rooms_delete(room_id)
      self.class.post(hipchat_api_url_for('rooms/delete'), :body => {:auth_token => @token, :room_id => room_id})      
    end

    # Fetch chat history for this room. 
    #
    # @param room_id [int] ID of the room.
    # @param date [String] Either the date to fetch history for in YYYY-MM-DD format, or "recent" to fetch the latest 50 messages.
    # @param timezone [String] Your timezone. Must be a supported PHP timezone. (default: UTC)
    #
    # @see https://www.hipchat.com/docs/api/method/rooms/history
    def rooms_history(room_id, date, timezone)
      self.class.get(hipchat_api_url_for('rooms/history'), :query => {:auth_token => @token, :room_id => room_id, :date => date, 
        :timezone => timezone})
    end

    # List rooms for this group. 
    #   
    # @see https://www.hipchat.com/docs/api/method/rooms/list
    def rooms_list
      self.class.get(hipchat_api_url_for('rooms/list'), :query => {:auth_token => @token})
    end
    
    # Send a message to a room.
    # 
    # @param room_id [int] ID of the room.
    # @param from [String] Name the message will appear be sent from. Must be less than 15 characters long. May contain letters, numbers, -, _, and spaces.
    # @param message [String] The message body. Must be valid XHTML. HTML entities must be escaped (e.g.: &amp; instead of &). May contain basic tags: a, b, i, strong, em, br, img, pre, code. 5000 characters max. 
    # @param notify [int] Boolean flag of whether or not this message should trigger a notification for people in the room (based on their individual notification preferences). 0 = false, 1 = true. (default: 0)
    # @param color [String] Background color for message. One of "yellow", "red", "green", "purple", or "random". (default: yellow) 
    # @param message_format [String] Determines how the message is treated by HipChat's server and rendered inside HipChat applications. One of "html" or "text". (default: html)
    # @see https://www.hipchat.com/docs/api/method/rooms/message
    def rooms_message(room_id, from, message, notify = 0, color = 'yellow', message_format = 'html')
      self.class.post(hipchat_api_url_for('rooms/message'), :body => {:auth_token => @token, :room_id => room_id, :from => from, 
        :message => message, :notify => notify, :color => color, :message_format => message_format})
    end

    # Get room details.
    # 
    # @param room_id [int] ID of the room.
    #
    # @see https://www.hipchat.com/docs/api/method/rooms/show
    def rooms_show(room_id)
      self.class.get(hipchat_api_url_for('rooms/show'), :query => {:auth_token => @token, :room_id => room_id})
    end
        
    # Create a new user in your group.
    # 
    # @param email [String] User's email.
    # @param name [String] User's full name. 
    # @param title [String] User's title. 
    # @param is_group_admin [int] Whether or not this user is an admin. 0 = false, 1 = true. (default: 0) 
    # @param password [String, nil] User's password. If not provided, a randomly generated password will be returned. 
    # @param timezone [String, 'UTC'] User's timezone. Must be a PHP supported timezone. (default: UTC) 
    #
    # @see https://www.hipchat.com/docs/api/method/users/create
    def users_create(email, name, title, is_group_admin = 0, password = nil, timezone = 'UTC')
      self.class.post(hipchat_api_url_for('users/create'), :body => {:auth_token => @token, :email => email, :name => name, :title => title, 
        :is_group_admin => is_group_admin, :password => password, :timezone => timezone}.reject!{|key, value| value.nil?})
    end

    # Delete a user. 
    # 
    # @param user_id [String] ID or email address of the user. 
    #
    # @see https://www.hipchat.com/docs/api/method/users/delete
    def users_delete(user_id)
      self.class.post(hipchat_api_url_for('users/delete'), :body => {:auth_token => @token, :user_id => user_id})
    end

    # List all users in the group. 
    #
    # @see https://www.hipchat.com/docs/api/method/users/list
    def users_list
      self.class.get(hipchat_api_url_for('users/list'), :query => {:auth_token => @token})
    end

    # Get a user's details. 
    # 
    # @param user_id [String] ID or email address of the user. 
    #
    # @see https://www.hipchat.com/docs/api/method/users/show
    def users_show(user_id)
      self.class.get(hipchat_api_url_for('users/show'), :query => {:auth_token => @token, :user_id => user_id})
    end

    # Update a user.
    # 
    # @param email [String] User's email.
    # @param name [String] User's full name. 
    # @param title [String] User's title. 
    # @param is_group_admin [int] Whether or not this user is an admin. 0 = false, 1 = true. (default: 0) 
    # @param password [String, nil] User's password.
    # @param timezone [String, nil] User's timezone. Must be a PHP supported timezone. (default: UTC) 
    #
    # @see https://www.hipchat.com/docs/api/method/users/update
    def users_update(user_id, email = nil, name = nil, title = nil, is_group_admin = nil, password = nil, timezone = nil)
      self.class.post(hipchat_api_url_for('users/update'), :body => {:auth_token => @token, :user_id => user_id, :email => email, 
        :name => name, :title => title, :is_group_admin => is_group_admin, :password => password, :timezone => timezone}.reject!{|key, value| value.nil?})
    end
    
    private
    
    # Create a URL appropriate for accessing the HipChat API with a given API method.
    #
    # @param method [String] HipChat API method
    #
    # @return URL appropriate for accessing the HipChat API with a given API method.
    def hipchat_api_url_for(method)
      "#{@hipchat_api_url}/#{method}"
    end
  end
end