module Compositor
  module Renderer
    class Base
      attr_reader :composite, :collection

      def initialize(composite, collection)
        @composite = composite
        @collection = collection
      end

      def render
        raise NoMethodError.new "Define render() method in subclasses!"
      end
    end
  end
end

require_relative 'iterator'
require_relative 'merged'
