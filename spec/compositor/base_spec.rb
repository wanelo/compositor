require 'spec_helper'

describe Compositor::Base do
  describe "#root_class_name" do
    it "returns the underscored class name" do
      Compositor::Base.root_class_name(Object).should == "object"
    end

    it "returns the underscored class name with compositor stripped out" do
      Compositor::Base.root_class_name(DslStringCompositor).should == "dsl_string"
    end

    it "raises exception when two subclasses that clash on the same name are defined" do
      block = lambda {
        # first class
        class UserCompositor < Compositor::Leaf
        end

        # 2nd class
        module ::Foo
          class UserCompositor < Compositor::Leaf
          end
        end
      }
      expect { block.call }.to raise_error
    end

    it "does not add DSL when class name begins with Abstract" do
      block = lambda {
        class AbstractUserCompositor < Compositor::Leaf
        end
        # Normally this would cause an exception, but since they both
        # start with Abstract, neither is added to the DSL.
        module ::Foo
          class AbstractUserCompositor < Compositor::Leaf
          end
        end
      }
      expect { block.call }.not_to raise_error
      Compositor::DSL.instance_methods.should_not include(:abstract_user)
    end

  end
end
