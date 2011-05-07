require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fakeweb'

describe "HipChat::API" do
  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @hipchat_api = HipChat::API.new('token')
  end
    
  it "should be the correct version" do
    HipChat::API::VERSION.should == '1.0.0'
  end
  
  it "should create a new instance with the correct parameters" do  
    @hipchat_api.token.should == 'token'
    @hipchat_api.hipchat_api_url.should == HipChat::API::HIPCHAT_API_URL
  end
  
  it "should allow http headers to be set" do
    @hipchat_api.expects(:headers).at_least_once
    
    @hipchat_api.set_http_headers({'Accept' => 'application/json'})
  end
  
  it "should allow a timeout to be set" do
    @hipchat_api.expects(:default_timeout).at_least_once
    
    @hipchat_api.set_timeout(10)
  end
  
  it "should return a list of rooms" do
    FakeWeb.register_uri(:get, 
                         %r|#{HipChat::API::HIPCHAT_API_URL}/rooms/list|, 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'rooms_list_response.json'), 
                         :content_type => "application/json")
  
    rooms_list_response = @hipchat_api.rooms_list
    rooms_list_response.should_not be nil
    rooms_list_response['rooms'].size.should be 2
  end
  
  it "should return the correct room informaton for a room_id" do
    FakeWeb.register_uri(:get, 
                         %r|#{HipChat::API::HIPCHAT_API_URL}/rooms/show|, 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'rooms_show_response.json'), 
                         :content_type => "application/json")
  
    rooms_show_response = @hipchat_api.rooms_show(7)
    rooms_show_response.should_not be nil
    rooms_show_response['room']['topic'].should == 'Chef is so awesome.'
  end
  
  after(:each) do
    FakeWeb.allow_net_connect = true
  end
end
