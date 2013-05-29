require 'spec_helper'

describe Compositor::Cache do
  let(:view_context) { Object.new }

  let(:key) { 'test123' }

  before do
    Compositor.cache = SampleCache.new
  end

  context 'cache already exists' do
    it 'doesnt evaluate the block if the value is in cache' do
      executed = false
      cache_key = key
      Compositor.cache.write(key, 'asdflkjrelkj')

      Compositor::DSL.create(view_context) do
        cache key: cache_key do
          executed = true
        end
      end.to_hash

      expect(executed).to be_false
    end
  end

  context 'cache does not exists' do

    it 'evaluates the block correctly' do
      executed = 0
      cache_key = key

      3.times do
        Compositor::DSL.create(view_context) do
          cache key: cache_key do
            executed += 1
          end
        end.to_hash
      end

      expect(executed).to be(1)
    end

    it 'caches the value' do
      integers = [1, 2, 3]
      expected = {
        tests: [
          {number: 1},
          {number: 2},
          {number: 3}
        ]
      }
      cache_key = key

      actual = Compositor::DSL.create(view_context) do
        cache key: cache_key do
          list root: :tests, collection: integers do |item|
            dsl_int item
          end
        end
      end.to_hash

      expect(actual).to eq(expected)

      expect(Compositor.cache.read(key)).to eq(expected)
    end
  end
end
