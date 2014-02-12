module Compositor
  class Leaf < Compositor::Base

    def root
      if @root.is_a?(Symbol)
        super
      elsif @root
        self.class.original_dsl_name.to_sym
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
