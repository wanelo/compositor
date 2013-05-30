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

For each model that needs a hash/json representation you need to create a ruby class that subclasses ```Composite::Leaf```,
adds some custom state that's important for rendering that object in addition to ```view_context```, and implement the ```#to_hash```
method.

The ```view_context``` variable is a reference to an object holding necessary helpers for generating JSON, for example
view_context is automatically available inside Rails controllers, and contains helper methods necessary to generate application URLs.
Outside of Rails application, ```view_context``` can be any other object holding application helpers or state.  All
subclasses of ```Compositor::Leaf``` inherit view_context reference, and can use it to construct Hash representations.

We recommend you place your Compositor classes in eg ```app/compositors/*``` directory, that has one compositor
class per model class you will be rendering. Example below would be ```app/compositors/user.rb```, a compositor class
wrapping ```User``` model.

```ruby
# The actual class name "User" is converted into a DSL method named "user", shown later.

class UserCompositor < Compositor::Leaf
  attr_accessor :user

  def initialize(context, user, attrs = {})
    super(context, attrs)
    self.user = user
  end

  def to_hash
    {
        id: user.id,
        username: user.username,
        location: user.location,
        bio: user.bio,
        url: user.url,
        image_url: context.image_path(user.avatar),
        ...
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

In the example below, application defines also ```StoreCompositor```, ```ProductCompositor``` classes
that similar to ```UserCompositor``` return hash representations of each model object.

```ruby

   compositor = Compositor::DSL.create(context) do
     map do
       store @store, root: :store
       user @user, root: :user
       list collection: @products, root: :products do |p|
         product p
       end
     end
   end

   puts compositor.to_hash # =>

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
         url: "",
         image_url: "http://cdn-app.domain.com/kigster/avatar/200.jpg"
      },
      :products => {
           [ id: 1234, :name => "Awesome Product", ... ],
           [ id: 4325, :name => "Another Awesome Product", ... ]
      }
   }
```

The context is an object that can contain helpers, instance variables, or anything that can be used
within leaves. For example, you can pass in the view_context from the controller to get access to any
Rails routes or helpers.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Maintainers

Konstantin Gredeskoul (@kigster) and Paul Henry (@letuboy)

(c) 2013, All rights reserved, distributed under MIT license.
