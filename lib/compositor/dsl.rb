module Compositor
  class DSL
    attr_reader :view_context
    attr_accessor :result, :generator

    def initialize(view_context)
      @view_context = view_context
    end

    def self.create(view_context, &block)
      dsl = new(view_context)
      dsl.instance_eval &block if block
      dsl
    end

    def paginate collection, params
      paginator collection: collection,
                pagination_url: params[:pagination_url],
                params: params[:api_params]
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

