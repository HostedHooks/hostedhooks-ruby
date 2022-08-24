# HostedHooks Ruby Gem

A Ruby library for [HostedHooks](https://www.hostedhooks.com),  a Webhooks as a Service Platform

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hostedhooks'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hostedhooks

## How it works

### Authentication

Initialize the gem with your API key that is [found here](https://www.hostedhooks.com/settings/account)

     client = HostedHooks::Client.new('API_KEY')

### Get one record

    client.get_endpoint("endpoint_uuid")


### Get a collection of records


    client.list_subscriptions("app_uuid")

### Create a record

    client.create_app(name: "Test App Name")

### Update a record

    client.update_app("app_uuid", name: "Test App Name")


## Resources

* Apps
* Subscriptions
* Endpoints
* Webhook Events
* Messages


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hostedhooks-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/HostedHooks/hostedhooks-ruby/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Hostedhooks::Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/HostedHooks/hostedhooks-ruby/blob/master/CODE_OF_CONDUCT.md).

## License
The gem is available as open source under the terms of the MIT License.
