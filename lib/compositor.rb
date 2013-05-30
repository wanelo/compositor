require 'compositor/version'

module Compositor
end

unless "".respond_to?(:constantize)
  class String
    def constantize
      camel_cased_word = self
      unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
        raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
      end

      Object.module_eval("::#{$1}", __FILE__, __LINE__)
    end
  end
end

unless "".respond_to?(:underscore)
  class String
    def underscore
      self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        downcase
    end
  end
end

require_relative 'compositor/base'
require_relative 'compositor/renderer/base'
