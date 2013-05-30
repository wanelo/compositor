module Compositor
  class Literal < Compositor::Leaf
    attr_accessor :object

    def initialize(view_context, object = {}, args = {})
      super(view_context, args)
      self.object = object
    end

    def to_hash
      object
    end
  end
end
