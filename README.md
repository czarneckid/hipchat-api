# hipchat-api

[![Project Status](http://stillmaintained.com/czarneckid/hipchat-api.png)](http://stillmaintained.com/czarneckid/hipchat-api) [![Build Status](https://travis-ci.org/czarneckid/hipchat-api.png)](https://travis-ci.org/czarneckid/hipchat-api)

Ruby gem for interacting with HipChat API

* https://www.hipchat.com/docs/api

## Compatibility

hipchat-API has been tested under Ruby 1.9.3

## Requirements

* HTTParty

## Install

```
gem install hipchat-api
```

## Example

```ruby
require 'hipchat-api'
=> true
hipchat_api = HipChat::API.new('api_token')
=> #<HipChat::API:0x000001013d7280 @token="api_token", @hipchat_api_url="https://api.hipchat.com/v1">
```

## API methods

* Room-related methods

```ruby
rooms_create(name, owner_user_id, privacy = 'public', topic = '', guest_access = 0)
rooms_delete(room_id)
rooms_list
rooms_history(room_id, date, timezone)
rooms_message(room_id, from, message, notify = 0, color = 'yellow', message_format = 'html')
rooms_topic(toom_id, topic, from = 'API')
rooms_show(room_id)
```

* User-related methods

```ruby
users_list(include_deleted = 0)
users_create(email, name, title, is_group_admin = 0, password = nil, timezone = 'UTC')
users_delete(user_id)
users_show(user_id)
users_undelete(user_id)
users_update(user_id, email = nil, name = nil, title = nil, is_group_admin = nil, password = nil, timezone = nil)
```

## Contributing to hipchat-api

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011-2014 David Czarnecki. See LICENSE.txt for further details.
