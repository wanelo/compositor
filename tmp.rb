class Tmp
  def self.iii
    self.instance_variable_get(:@iii)
  end
end

class Aaa < Tmp
end

class Bbb < Aaa
end


c = Class.new(Aaa) do
  def self.make nm,val
    self.class.send :define_method, nm do
       val
    end
  end
end



c.make :foo, "bar"
c.make :foo1, "bar1"
puts c.foo
puts c.foo1

val = 10
c.define_singleton_method(:bla) { val }

puts c.bla

class F < c

end


puts F.foo
puts F.bla
exit(0);


#Aaa.class.send(:define_method, :foo) do
#    18
#end


#puts Aaa.foo
#puts Tmp.foo

val=10
c = Class.new(Aaa)
c.instance_eval do
  self.send(:define_method,:foo) do
    v
  end
end

puts c.methods.sort
puts c.new.methods.sort

Aaa.instance_eval do
  def foo
    18
  end
  #send(:define_method, :foo) do
  #  18
  #end
end

puts Aaa.foo



