require 'spec_helper'

describe Compositor::DSL do

  let(:context) { Object.new }

  describe '#empty' do
    it 'returns the default type' do
      dsl = Compositor::DSL.create(context) do
      end

      nil.should == dsl.to_hash
    end
  end

  describe 'instance variables' do
    it 'allows instance variables from the view context to be accessed in the dsl evaluation' do
      context.instance_eval do
        @blah = 1
      end

      Compositor::DSL.create(context) do
        raise "Instance variable should be available in DSL" unless @blah == 1
      end
    end
  end
end
