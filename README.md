Compositor
=====

[![Build status](https://secure.travis-ci.org/wanelo/compositor.png)](http://travis-ci.org/wanelo/compositor)

Composite pattern with a neat DSL for constructing trees of objects in order to render them as a Hash, and subsequently
JSON.  Used by Wanelo to generate all JSON API responses by compositing multiple objects together, converting to
a hash and then JSON.


## Installation

Add this line to your application's Gemfile:

    gem 'compositor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compositor

## Usage

For each model that needs a hash/json representation you need to create a ruby class that subclasses Composite::Leaf,
adds some custom state that's important for rendering that object in addition to view_context, and implements one of the
two methods:

#to_hash method

```ruby
# The actual class name "User" is convered into
# a DSL method named "user", shown later.

class Compositor::User < Compositor::Leaf
  attr_accessor :user

  def initialize(view_context, user, attrs = {})
    super(view_context, attrs)
    self.user = user
  end

  def to_hash
    {
        id: user.id,
        username: user.username,
        location: user.location,
        bio: user.bio,
        url: user.url
    }
  end
end
```

This small class automatically registers "user" DSL method, which receives a user object and any other
important attributes.

Then this class can be merged with other similar "leaf" classes, or another "composite" class, such as
Composite::Map or Composite::List to create a Hash or an Array as the top-level JSON data structure.

Once the tree of composite objects has been setup, calling #to_hash on the top level object quickly
generates hash by walking the tree and merging everything together.



```ruby

   composite = Composite.create(view_context) do
     map do
       store store, root: :store
       user current_user, root: :user
       list collection: products, root: :products do |p|
         product p
       end
     end
   end

   puts composite.to_hash # =>

   {
      :store => {
         id: 12354,
         name: "amazon.com",
         url: "http://www.amazon.com",
         ..
      },
      :user => {
         id: 1234,
         username: "kigster",
         location: "San Francisco",
         bio: "",
         url: ""
      },
      :products => {
           [ id: 1234, :name => "Awesome Product", ... ],
           [ id: 4325, :name => "Another Awesome Product", ... ]
      }
   }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Maintainers

Konstantin Gredeskoul (@kigster) and Paul Henry (@letuboy)

(c) 2013, All rights reserved, distributed under MIT license.
