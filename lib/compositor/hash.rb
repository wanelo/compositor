module Compositor
  class Hash < ::Compositor::Composite
    def renderer
      @renderer ||= Compositor::Renderer::Merged
    end
  end
end
