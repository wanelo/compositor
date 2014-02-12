class MapCompositor < ::Compositor::Composite
  def renderer
    @renderer ||= Compositor::Renderer::Merged
  end
end
