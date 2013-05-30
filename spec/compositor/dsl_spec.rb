require 'spec_helper'

describe Compositor::DSL do

  let(:view_context) { Object.new }

  describe '#empty' do
    it 'returns the default type' do
      dsl = Compositor::DSL.create(view_context) do
      end

      nil.should == dsl.to_hash
    end
  end
end
