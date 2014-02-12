class DslStringCompositor < Compositor::Leaf
  attr_accessor :string

  def to_hash
    with_root_element do
      {
        a: "b"
      }
    end
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
