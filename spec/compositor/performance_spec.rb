require_relative '../spec_helper'

describe 'Performance' do

  let(:view_context) { Object.new }
  let(:permitted_dsl_performance_penalty) { 60 } # 60% slower is allowed, any slower is not.)

  describe 'generating DSL' do
    before do
      require 'benchmark'
      @timing = { }
    end

    it "is no more than 60% slower than non-DSL" do
      dsl = nil
      output = Benchmark.measure do
        10000.times do
          dsl = Compositor::DSL.create(view_context) do |dsl|
            map do
              dsl_string "hello"
              dsl_int 3
              list collection: [1, 2, 3], root: :numbers do |number|
                dsl_int number
              end
            end
          end
          dsl.to_hash.should == {:a => "b", :number => 3, :numbers => [{:number => 1}, {:number => 2}, {:number => 3}]}
        end
      end

      @timing[:dsl] = output.to_s.to_f

      cmp = nil
      output = Benchmark.measure do
        10000.times do
          string = Compositor::Leaf::DslString.new(view_context)
          int = Compositor::Leaf::DslInt.new(view_context, 3)
          list = Compositor::List.new(view_context,
                                      root: :numbers,
                                      collection: [1, 2, 3].map! { |n| Compositor::Leaf::DslInt.new(view_context, n) })
          cmp = Compositor::Map.new(view_context, collection: [string, int, list])
          cmp.to_hash.should == {:a => "b", :number => 3, :numbers => [{:number => 1}, {:number => 2}, {:number => 3}]}
        end
      end

      @timing[:nodsl] = output.to_s.to_f

      difference = (100 * (@timing[:dsl] - @timing[:nodsl]) / @timing[:nodsl])
      difference.should be < permitted_dsl_performance_penalty, "DSL generation was more than #{permitted_dsl_performance_penalty}% slower than non-DSL"
    end
  end
end
