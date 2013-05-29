class SampleCache
  attr_accessor :cache

  def initialize
    @cache = {}
  end

  def write(key, value)
    cache[key] = value
    value
  end

  def read(key)
    cache[key]
  end

  def fetch(key, options = {})
    value = read(key)
    return value unless value.nil?
    write key, yield
  end
end
