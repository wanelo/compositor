module Compositor
  class Literal < Compositor::Leaf
    def initialize(view_context, object = {}, args = {})
      super(view_context, {object: object}.merge!(args))
    end

    def to_hash
      object
    end
  end
end
