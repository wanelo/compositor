module Compositor
  module Renderer
    class Iterator < Base
      def render
        result = []
        collection.each do |item|
          result << item.to_hash
        end
        result
      end
    end
  end
end
