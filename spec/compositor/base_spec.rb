require 'spec_helper'

describe Compositor::Base do
  describe "#original_dsl_name" do
    it "returns the underscored class name with compositor stripped out" do
      DslStringCompositor.original_dsl_name.should == "dsl_string"
    end
  end

  describe '.inherited' do
    describe "when class is defined inside a module" do
      it "returns the underscored class name with compositor stripped out but with the module added" do
        module Exploding
          class ExplosionCompositor < Compositor::Leaf
          end
        end

        expect(Compositor::DSL.instance_methods).to include(:exploding_explosion)
      end
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
