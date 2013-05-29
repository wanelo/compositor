module Compositor
  class Composite < Compositor::Base
    attr_accessor :collection, :renderer

    def initialize(view_context, *args)
      super
      self.collection ||= []
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

    def self.inherited(subclass)
      method_name = subclass.name.gsub(/.*::/, '').underscore
      unless method_name.eql?("base")
        Compositor::DSL.send(:define_method, method_name) do |args = {}, &block|
          original_generator = self.generator
          composite = subclass.new(self.view_context, args)

          self.generator = composite

          if args[:collection] && block
            # reset collection, we'll be mapping it via a block
            composite.collection = []
            args[:collection].each do |object|
              self.instance_exec(object, &block)
            end
          elsif block
            self.instance_eval &block
          end

          if original_generator
            self.generator = original_generator
            self.generator.collection << composite
          end
        end
      end
    end
  end
end
