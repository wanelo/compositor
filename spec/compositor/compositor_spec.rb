require_relative '../spec_helper'

describe Compositor::DSL do

  let(:view_context) { Object.new }

  describe '#create' do
    it "defines #dsl_string method on the DSL class" do
      dsl = Compositor::DSL.create(view_context)
      dsl.should respond_to(:dsl_string)
    end

    it "allows calling defined methods via a block" do
      block_ran = false
      Compositor::DSL.create(view_context) do |dsl|
        dsl.dsl_string
        block_ran = true
      end
      block_ran.should be_true
    end

    it "returns last generator called via block" do
      dsl = Compositor::DSL.create(view_context) do |dsl|
        dsl.dsl_string
      end

      {a: "b"}.should == dsl.to_hash
    end

    it "returns an instance of subclass" do
      dsl = Compositor::DSL.create(view_context).dsl_string
      dsl.should be_kind_of(Compositor::Leaf::DslString)
    end
  end

  describe '#composite' do
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

    it 'returns the generated hash' do
      expected = {
          tests: {
              num1: {number: 1},
              num2: {number: 2},
              num3: {number: 3}
          }
      }

      dsl = Compositor::DSL.create(view_context)
      dsl.hash root: :tests do
        dsl.dsl_int 1, root: :num1
        dsl.dsl_int 2, root: :num2
        dsl.dsl_int 3, root: :num3
      end

      expected.should == dsl.to_hash
    end

    it 'returns the generated deeply nested hash' do
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

      dsl = Compositor::DSL.create(view_context)
      dsl.hash root: :tests do
        dsl.dsl_int 1, root: :num1
        dsl.dsl_int 2, root: :num2
        dsl.dsl_int 3, root: :num3
        dsl.list :root => :stuff do
          dsl.dsl_int 10
          dsl.dsl_int 11
        end
      end

      expected.should == dsl.to_hash
    end

    it 'returns the generated deeply nested hash without explicit receiver' do
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

      dsl = Compositor::DSL.create(view_context)
      dsl.hash root: :tests do
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
  end

  describe '#empty' do
    it 'returns the default type' do
      dsl = Compositor::DSL.create(view_context) do
      end

      nil.should == dsl.to_hash

      dsl = Compositor::DSL.create(view_context) do
        hash collection: [], root: false
      end

      {}.should == dsl.to_hash

      dsl = Compositor::DSL.create(view_context) do
        list collection: [], root: false
      end

      [].should == dsl.to_hash

    end
  end
end
