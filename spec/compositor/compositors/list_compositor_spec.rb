require 'spec_helper'

describe ListCompositor do
  let(:context) { Object.new }

  it 'returns the generated array with the explicit receiver' do
    integers = [1, 2, 3]
    expected = {
      tests: [
        {number: 1},
        {number: 2},
        {number: 3}
      ]
    }

    dsl = Compositor::DSL.create(context)
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

    dsl = Compositor::DSL.create(context)
    dsl.list root: :tests, collection: integers do |item|
      dsl_int item
    end

    expected.should == dsl.to_hash
  end

  describe '#empty' do
    it 'returns the default type' do
      dsl = Compositor::DSL.create(context) do
        list collection: [], root: false
      end

      [].should == dsl.to_hash
    end

    it 'doesnt execute the block if an empty collection is passed' do
      dsl = Compositor::DSL.create(context) do
        list collection: [], root: false do |p|
          raise "Shouldnt be a DSL" if p.instance_of?(Compositor::DSL)
        end
      end

      [].should == dsl.to_hash
    end
  end
end
