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

  # Mimic method so you can overide leave name in a class. Since base uses
  # inherited callback this option does not currently exited in the class
  # itself.
  def self.AbstractLeaf hsh
    raise "Abstract leaf hsh must contain :as element" unless hsh[:as]
    clazz = Class.new(Compositor::Base)
    clazz.class_eval "def self.dsl_override; '#{hsh[:as]}'; end;"
    clazz
  end

end
