module Compositor
  class Leaf::DslString < Compositor::Leaf
    def to_hash
      {
          a: "b"
      }
    end
  end

  class Leaf::DslInt < Compositor::Leaf
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

  class Leaf::DslObject < Compositor::Leaf
    def to_hash
      {
          a: object
      }
    end
  end
end
