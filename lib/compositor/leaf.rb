module Compositor
  class Leaf < Compositor::Base
    attr_accessor :object

    def initialize(view_context, object = {}, args = {})
      if object.is_a?(::Hash)
        super(view_context, object)
      else
        super(view_context, {object: object}.merge!(args))
      end
    end

    def root
      if @root.is_a?(Symbol)
        super
      elsif @root
        root_class_name.to_sym
      else
        nil
      end
    end

    def composite?
      false
    end

    def self.inherited(subclass)
      method_name = root_class_name(subclass)
      unless method_name.eql?("base")
        Compositor::DSL.send(:define_method, method_name) do |*args|
          leaf = subclass.new(@view_context, *args)
          if self.generator
            raise "Leaves should be called within composite" unless self.generator.composite?
            self.generator.collection << leaf
          else
            self.generator = leaf
          end
          leaf
        end
      end
    end
  end
end
