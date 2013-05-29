module Compositor
  class List < Compositor::Composite
    def renderer
      @renderer ||= Compositor::Renderer::Iterator
    end
  end
end
