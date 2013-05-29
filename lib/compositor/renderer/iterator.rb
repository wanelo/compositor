module Compositor
  module Renderer
    class Iterator < Base
      def render
        collection.inject([]) { |memo, item| memo << item.to_hash; memo }
      end
    end
  end
end
