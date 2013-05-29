module Compositor
  module Renderer
    class Merged < Base
      def render
        return {} if collection.nil? or collection.size == 0
        return collection.first.to_hash if collection.length == 1
        collection.inject({}) do |result, hash|
          result.merge!(hash.to_hash)
        end
      end
    end
  end
end
