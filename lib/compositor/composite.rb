module Compositor
  class Composite < Compositor::Base
    attr_accessor :collection, :renderer

    def initialize(view_context, args = {})
      super

      @collection_set = true if args[:collection]
      self.collection ||= default
    end

    def default=(value)
      @default_set = true
      @default = value
    end

    def default
      @default_set ? @default : []
    end

    def to_hash
      with_root_element do
        renderer.new(self, collection).render
      end
    end

    def map_collection
      self.collection = self.collection.map do |item|
        yield item
      end
    end

    def composite?
      true
    end

    def map_to_dsl!(dsl, &block)
      original_generator = dsl.generator

      dsl.generator = self

      if @collection_set && block
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
    end

    def define_with_dsl!(dsl, &block)
      map_to_dsl!(dsl, &block)

      dsl.generator.collection << self if dsl.generator != self
    end
  end
end
