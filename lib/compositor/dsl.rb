module Compositor
  class DSL
    attr_reader :view_context
    attr_accessor :generator

    def initialize(view_context)
      @view_context = view_context
    end

    def self.create(view_context, &block)
      dsl = new(view_context)
      dsl.instance_eval &block if block
      dsl
    end

    def to_json
      generator.to_json
    end

    def to_hash
      if generator
        generator.to_hash
      else
        nil
      end
    end
  end
end

