require 'spec_helper'

describe Compositor::List do
  let(:view_context) { Object.new }

  it 'returns the generated array with the explicit receiver' do
    integers = [1, 2, 3]
    expected = {
      tests: [
        {number: 1},
        {number: 2},
        {number: 3}
      ]
    }

    dsl = Compositor::DSL.create(view_context)
    dsl.list root: :tests, collection: integers do |item|
      dsl.dsl_int item
    end

    dsl.to_hash.should == expected
  end

  it 'returns the generated array with explicit receiver' do
    integers = [1, 2, 3]
    expected = {
      tests: [
        {number: 1},
        {number: 2},
        {number: 3}
      ]
    }

    dsl = Compositor::DSL.create(view_context)
    dsl.list root: :tests, collection: integers do |item|
      dsl_int item
    end

    expected.should == dsl.to_hash
  end

  describe '#empty' do
    it 'returns the default type' do
      dsl = Compositor::DSL.create(view_context) do
        list collection: [], root: false
      end

      [].should == dsl.to_hash
    end
  end
end
