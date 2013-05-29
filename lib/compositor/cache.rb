module Compositor
  class Cache < ::Compositor::Hash
    attr_accessor :key, :expires_in, :block, :dsl

    def to_hash
      raise 'Must use cache with dsl' if dsl.nil?
      raise 'Must use cache with block' if block.nil?

      Compositor.cache.fetch key, expires_in: expires_in do
        map_to_dsl!(dsl, &block)

        super
      end
    end

    def define_with_dsl!(dsl, &block)
      self.block = block
      self.dsl = dsl

      if dsl.generator
        dsl.generator.collection << self
      else
        dsl.generator = self
      end
    end
  end
end
