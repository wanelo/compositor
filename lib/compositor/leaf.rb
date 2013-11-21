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
  # Note we use an interstitial anonymous class since the DSL builder relies
  # on self.inherited. Could get more in terms of flexibility if this used
  # module inheritance instead. But this works fine with snytax borrows from
  # Camping and Sequal.
  #
  # Example:
  #
  #module Motley
  #  class Crew < Compositor::NamedLeaf("motley_crew")
  #  end
  #end
  #
  #module TwoLive
  #  class Crew < Compositor::NamedLeaf("two_live_crew")
  #  end
  #end


  def self.NamedLeaf name
    Class.new(Compositor::Leaf) do
      eigenclass = class << self; self; end;
      eigenclass.send(:define_method, :dsl_override) { name }
    end
  end

end
