module Compositor
  class Leaf < Compositor::Base
    attr_accessor :object

    def initialize(view_context, object = {}, args = {})
      if object.is_a?(::Hash)
        super(view_context, object)
      else
        super(view_context, {object: object}.merge!(args))
      end
    end

    def root
      if @root.is_a?(Symbol)
        super
      elsif @root
        root_class_name.to_sym
      else
        nil
      end
    end

    def composite?
      false
    end

    def dsl(dsl)
      if dsl.generator
        raise "Leaves should be called within composite" unless dsl.generator.composite?
        dsl.generator.collection << self
      else
        dsl.generator = self
      end
    end
  end
end
