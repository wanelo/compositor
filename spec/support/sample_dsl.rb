class DslStringCompositor < Compositor::Leaf
  attr_accessor :string

  def to_hash
    {
        a: "b"
    }
  end
end

class DslIntCompositor < Compositor::Leaf
  attr_accessor :number

  def initialize(view_context, number, attrs = {})
    super(view_context, {number: number}.merge!(attrs))
  end

  def to_hash
    with_root_element do
      {
          number: @number
      }
    end
  end
end

class DslObjectCompositor < Compositor::Leaf
  attr_accessor :object

  def to_hash
    {
        a: object
    }
  end
end

module PublicApi
  class Person < Compositor::NamedLeaf("api_person")
    def to_hash
      with_root_element do
        {
            name: "bob",
            age: 12
        }
      end
    end
  end
end

module PrivateApi
  class Person < Compositor::NamedLeaf("internal_person")
    attr_accessor :salary

    def initialize(view_context, salary, attrs = {})
      super(view_context, {salary: salary}.merge!(attrs))
    end

    def to_hash
      with_root_element do
        {
            name: "squiggy",
            salary: salary,
            status: "baller"
        }
      end
    end
  end
end


module Api
  module V0
    class User < Compositor::NamedLeaf("v0_user")
      def to_hash
        # hash of stuff for v0 rep of user
      end
    end
  end
end

module Api
  module V1
    class User < Compositor::NamedLeaf("v1_user")
      def to_hash
        # hash of stuff v1 rep of user
      end
    end
  end
end



