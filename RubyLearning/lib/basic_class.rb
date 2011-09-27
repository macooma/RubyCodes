#
# The use of String class
# e. You can type any ruby expression in #{} 
#

puts "Secondes/day: #{24*60*60}"
puts "#{'Ho! '*3}Merry Chrismas!"
puts "This is line #$."

puts %q/general single-quoted string/
puts %Q!general double-quoted string!
puts %Q{Secondes/day: #{24*60*60}}

# here document
puts <<END_OF_STRING
The body of the string \
is the input lines up to \
onde ending with the same \
text that followd the '<<'
END_OF_STRING

puts <<-STRING1, <<-STRING2
Concat
STRING1
  enate
  STRING2
  
#
# The use of Ranges
#

1..10
'a'..'z'
my_array = [1,2,3]
0..my_array.length

(0..my_array.length).to_a

class VU
  include Comparable
  attr :volume
  def initialize(volume)
    @volume = volume
  end
  def inspect
    '#' * @volume
  end
  #support for ranges
  def <=>(other)
    self.volume <=> other.volume
  end
  def succ
    raise(IndexError, "Volume too big") if @volume >= 9
    VU.new(@volume.succ)
  end
end

medium_volume = VU.new(4)..VU.new(7)
medium_volume.to_a
medium_volume.include?(VU.new(3))

puts (1..10) === 5                #=> true
puts (1..10) === 15               #=> false 
puts (1..10) === 3.1415           #=> true
puts (1..10).include?(3.1415)     #=> true


