module Compositor
  class Map < ::Compositor::Composite
    def renderer
      @renderer ||= Compositor::Renderer::Merged
    end
  end
end
