Compositor
=====

[![Build status](https://secure.travis-ci.org/wanelo/compositor.png)](http://travis-ci.org/wanelo/compositor)

A Composite Design Pattern with a neat DSL for constructing trees of objects in order to render them as a Hash, and subsequently
JSON.  Used by Wanelo to generate all JSON API responses by compositing multiple objects together in API responses, converting to
a plain ruby Hash (or an Array) and then using OJ gem to convert Hash to JSON.

The performance of this approach is significantly faster than RABL, something we started with and abandoned due
to it's poor performance.

## Installation

Add this line to your application's Gemfile:

    gem 'compositor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compositor

## Usage

For each model that needs a hash/json representation you need to create a ruby class that subclasses ```Composite::Leaf```,
adds some custom state that's important for rendering that object in addition to ```context```, implements a proper constructor
(see example), and finally implement the main rendering ```#to_hash``` method (used as the "operation" in the Composite pattern
terminology).

The ```context``` variable is a reference to an object holding necessary helpers for generating JSON, for example
Rails Controllers expose a ```view_context``` instance, which contains helper methods necessary to generate application URLs.

Outside of Rails application, ```context``` can be any other object holding application helpers or state.  All
subclasses of ```Compositor::Leaf``` such as ```UserCompositor``` inherit ```context``` attribute and accessors, and so can
use the context in generating URLs, or calling any other application helpers.

We recommend that you place your Compositor classes in eg ```app/compositors/*``` directory, which defines one compositor
class per model class you will be rendering (although sometimes you may also want a ```CompactUserCompositor```, etc, for
performance reasons). In the example below, the file could be ```app/compositors/user.rb```,
a compositor class wrapping ```User``` model.

```ruby
# File: app/compositors/user_compositor.rb
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
        image_url: context.image_path(user.avatar),  # using context to generate URL path from routes
        ...
    }
  end
end
```

You could create this class directly, as in

```ruby

   uc = UserCompositor.new(view_context, user, {})
   uc.to_hash # => returns a Hash representation
   uc.to_json # => calls to_hash, and then renders JSON
```

But constructing trees of objects that represent a complex API responses requires a lot more than that, such as
constructing lists (arrays) or maps (hashes) of objects, and deciding which order they appear, and whether each
inner Hash comes with a "root" element, such as ```:product => { :id => 1, ... }``` where ```:product``` is the root
element.

So here is how to create a list of users in this way, but explicitly declaring classes:

```ruby
   compositor = Compositor::Map.new(view_context,
        :collection => @users.map{|user| UserCompositor.new(view_context, user, { :root => true }),
        :root => :users
```

When calling ```to_hash``` on the top level compositor, we get:

```ruby
:users => {
  :user => {
      id: 1234,
      username: "kigster",
      location: "San Francisco",
      bio: "",
      url: "",
      image_url: "http://cdn-app.domain.com/kigster/avatar/200.jpg"
  },
  :user => {
      id: 1235,
      username: "johnny",
      location: "Sunnyvale",
      bio: "",
      url: "",
      image_url: "http://cdn-app.domain.com/johnny/avatar/200.jpg"
  }
}
```

So this is how you can assemple multiple compositors together without the DSL.

But the real power of this gem is in the additional DSL class, that dramatically simplifies definition
of complex responses, as described below.

## Using the DSL

```UserCompositor``` class, when defined, automatically adds a ```user``` method to the DSL class, which effictively
instantiates the new UserCompositor instance, passing the context into it automatically.

Using provided ```Compositor::Map``` and ```Compositor::List``` we can construct multiple objects into a larger
hierarchy.

In the example below, an application also defines ```StoreCompositor```and ```ProductCompositor``` classes
similar to ```UserCompositor```, which also have the ```#to_hash``` method defined.

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

   # now we can call to_hash or to_json on the compositor:
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
      :products => [
           { id: 1234, :name => "Awesome Product", ... },
           { id: 4325, :name => "Another Awesome Product", ... }
      }
   }
```

Inside the list definition above, @products is a collection of Products, ActiveRecord objects,
and the block maps each to a Compositor using product() method, registered by ProductCompositor.

## Instance Variables

One thing to note, is that when ```Compositor::DSL``` is used, the gem copies all instance variables
from the ```context``` into the DSL instance, so in the above example instance variable ```@user```
was defined on ```view_context``` (by Rails, which copies them from the Controller instance), and
so became automatically available inside DSL.  Note that all instance variables must be
defined *before* the DSL instance is created.

## Performance

Note of caution: despite the fact that typical DSL generation can take mere 50-100 microseconds, defining complex responses
with DSL does carry a performance penantly of about 50% (we measured it!). Which generally means that generating
multiple Composite objects in a loop using the DSL is probably not recommended, but doing it once per web/API
request is completely reasonable.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Maintainers

Konstantin Gredeskoul (@kigster) and Paul Henry (@letuboy)

(c) 2013, All rights reserved, distributed under MIT license.
