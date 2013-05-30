module Compositor
  class DSL
    attr_reader :context
    attr_accessor :generator

    def initialize(context)
      @context = context
    end

    def self.create(context, &block)
      dsl = new(context)
      context.instance_variables.each do |variable|
        dsl.instance_variable_set(variable, context.instance_variable_get(variable))
      end
      dsl.instance_eval &block if block
      dsl
    end

    def to_json(options = {})
      generator.to_json(options)
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

