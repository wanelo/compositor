require 'spec_helper'

describe Compositor::Leaf do
  let(:context) { Object.new }

  describe '#create' do
    it "defines #dsl_string method on the DSL class" do
      dsl = Compositor::DSL.create(context)
      dsl.should respond_to(:dsl_string)
    end

    it "allows calling defined methods via a block" do
      block_ran = false
      Compositor::DSL.create(context) do |dsl|
        dsl.dsl_string
        block_ran = true
      end
      block_ran.should be_true
    end

    it "returns last generator called via block" do
      dsl = Compositor::DSL.create(context) do |dsl|
        dsl.dsl_string
      end

      {a: "b"}.should == dsl.to_hash
    end

    it "returns an instance of subclass" do
      dsl = Compositor::DSL.create(context).dsl_string
      dsl.should be_kind_of(DslStringCompositor)
    end
  end
end
