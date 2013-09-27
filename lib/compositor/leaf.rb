module Compositor
  class Leaf < Compositor::Base

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

  # Create a named leaf, To override the dsl name at the class level
  def self.NamedLeaf name
    Class.new(Compositor::Leaf) do
      define_singleton_method(:dsl_override) { name }
    end
  end

end
