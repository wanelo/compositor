module Compositor
  class Base
    attr_reader :attrs
    attr_accessor :root, :view_context

    def initialize(view_context, attrs = {})
      @attrs = attrs
      self.view_context = view_context
      attrs.each_pair do |key, value|
        self.send("#{key}=", value)
      end
    end

    def to_hash
      raise NotImplementedError.new("Abstract method, should be implemented by subclasses")
    end

    def with_root_element
      include_root? ? {root => yield} : yield
    end

    def to_h
      to_hash
    end

    def collection_to_generator(klazz, collection)
      collection.map { |o| klazz.new(view_context) }
    end

    def to_json(options = {})
      Oj.dump(to_hash)
    end

    def include_root?
      self.root ? true : false
    end

    def root_class_name
      self.class.root_class_name(self.class)
    end

    def self.root_class_name(klazz)
      klazz.name.gsub(/.*::/, '').underscore
    end

    def self.inherited(subclass)
      method_name = root_class_name(subclass)
      unless method_name.eql?("base")
        Compositor::DSL.send(:define_method, method_name) do |*args, &block|
          subclass.new(@view_context, *args).define_with_dsl!(self, &block)
        end
      end
    end

    def self.define_with_dsl!
      raise "Implement in subclasses"
    end
  end
end

require_relative 'dsl'
require_relative 'composite'
require_relative 'leaf'
require_relative 'list'
require_relative 'hash'
require_relative 'cache'
