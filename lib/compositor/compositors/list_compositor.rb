class ListCompositor < Compositor::Composite
  def renderer
    @renderer ||= Compositor::Renderer::Iterator
  end
end
