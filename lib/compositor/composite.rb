module Compositor
  class Composite < Compositor::Base
    attr_accessor :collection, :renderer

    def initialize(view_context, args = {})
      super
      self.collection ||= []
    end

    def to_hash
      with_root_element do
        renderer.new(self, collection).render
      end
    end

    def composite?
      true
    end

    def dsl(dsl, &block)
      original_generator = dsl.generator

      dsl.generator = self

      if self.collection && !self.collection.empty? && block
        # reset collection, we'll be mapping it via a block
        unmapped_collection = collection
        self.collection = []
        unmapped_collection.each do |object|
          dsl.instance_exec(object, &block)
        end
      elsif block
        dsl.instance_eval &block
      end

      dsl.generator = original_generator if original_generator

      dsl.generator.collection << self if dsl.generator != self
    end
  end
end
