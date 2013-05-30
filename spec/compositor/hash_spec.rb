require 'spec_helper'

describe Compositor::Map do
  let(:context) { Object.new }

  it 'returns the generated map' do
    expected = {
      tests: {
        num1: {number: 1},
        num2: {number: 2},
        num3: {number: 3}
      }
    }

    dsl = Compositor::DSL.create(context)
    dsl.map root: :tests do
      dsl.dsl_int 1, root: :num1
      dsl.dsl_int 2, root: :num2
      dsl.dsl_int 3, root: :num3
    end

    expected.should == dsl.to_hash
  end

  it 'returns the generated deeply nested map without explicit receiver' do
    expected = {
      tests: {
        num1: {number: 1},
        num2: {number: 2},
        num3: {number: 3},
        stuff: [
          {number: 10},
          {number: 11}
        ]
      }
    }

    dsl = Compositor::DSL.create(context)
    dsl.map root: :tests do
      dsl_int 1, root: :num1
      dsl_int 2, root: :num2
      dsl_int 3, root: :num3
      list :root => :stuff do
        dsl_int 10
        dsl_int 11
      end
    end

    expected.should == dsl.to_hash
  end

  describe '#empty' do
    it 'returns the default type' do
      dsl = Compositor::DSL.create(context) do
        map collection: [], root: false
      end

      {}.should == dsl.to_hash
    end
  end
end
