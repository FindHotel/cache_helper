# CacheHelper

A few methods that will make life easier when it is needed to cache ActiveRecord or Mongoid objects in memory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cache_helper'
```

And then execute:

    $ bundle

## Usage

Provides the following methods.
For explanation, we will assume we have a class called `Place` with `id,` `name`, `rating`, `city`, `longitude` and `latitude` attributes.

### `CacheHelper#simple_cache`
Create a simple key value cache, both key and value need to be provided.
```ruby
# (klass, selector, key, value)
CacheHelper.simple_cache(Place, { rating: 5.0 }, :id, :name)

# Will query for places with rating 5.0 and create an hash with ids as keys and names as values
#=> { 1 => 'FindHotel', 2 => 'Frederix', 5 => 'Ciao Bella' }
```

### `CacheHelper#key_to_object_cache`
Create a simple key object cache, pick a unique key and then the whole object will be the value
```ruby
# (klass, selector, key)
CacheHelper.key_to_object_cache(Place, { rating: 5.0 }, :id)
# Will query for places with rating 5.0 and create an hash with ids as keys and the object itself as value
#=> { 1 => #<Place:0x007f8c451dd2c8 id: 1, name: 'FindHotel'>,
#     2 => #<Place:0x007f8c451dd2c9 id: 2, name: 'Frederix'>,
#     5 => #<Place:0x007f8c451dd2d0 id: 5, name: 'Ciao Bella'> }
```

### `CacheHelper#key_to_objects_cache`
```ruby
# (klass, selector, key) or # (klass, selector, [keys_array])
# Good for grouping data

CacheHelper.key_to_objects_cache(Place, 'rating > 3', :rating)
#=> { 5.0 => [#<Place:0x007f8c451dd2c8 id: 1, name: 'FindHotel'>,
#     #<Place:0x007f8c451dd2c9 id: 2, name: 'Frederix'>,
#     #<Place:0x007f8c451dd2d0 id: 5, name: 'Ciao Bella'>]
#     4.0 => [...],
#     ...
#   }

# OR an array of keys

CacheHelper.key_to_objects_cache(Place, 'rating > 3', [:rating, :city])
#=> { [5.0, 'Amsterdam'] => [#<Place:0x007f8c451dd2c8 id: 1, name: 'FindHotel'>,
#     #<Place:0x007f8c451dd2c9 id: 2, name: 'Frederix'>,
#     #<Place:0x007f8c451dd2d0 id: 5, name: 'Ciao Bella'>]
#     [5.0, 'Berlin'] => [...],
#     [4.0, 'Berlin'] => [...],
#     ...
#   }
```

### `CacheHelper#key_presence_cache`
```ruby
# (klass, selector, key) or # (klass, selector, [keys_array])
# Good for caching the existence of a certain key/key combination in the database

CacheHelper.key_presence_cache(Place, 'rating > 3', :rating)
#=> { 5.0 => true,
#     4.0 => false,
#     3.1 => true,
#     ...
#   }

# OR an array of keys

CacheHelper.key_presence_cache(Place, 'rating > 3', [:rating, :city])
#=> { [5.0, 'Amsterdam'] => true, # there exists 5 star places in Amsterdam
#     [5.0, 'Berlin'] => [...], # there exists 5 star places in Berlin
#     [4.0, 'Berlin'] => [...], # there exists 4 star places in Berlin
#     ...
#   }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FindHotel/cache_helper.
