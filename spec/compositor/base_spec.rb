require 'spec_helper'

describe Compositor::Base do
  describe "#root_class_name" do
    it "returns the underscored class name" do
      Compositor::Base.root_class_name(Object).should == "object"
    end

    it "returns the underscored class name with compositor stripped out" do
      Compositor::Base.root_class_name(DslStringCompositor).should == "dsl_string"
    end
  end
end
