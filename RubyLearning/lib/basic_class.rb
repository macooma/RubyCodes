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
  
a = "the quick brown fox"
puts a.sub(/[aeiou]/, '*')
puts a.gsub(/[aeiou]/, '*')
puts a.sub(/\s\S+/, '')
puts a.gsub(/\s\S+/, '')
puts a.sub(/^./) { |match| match.upcase }
puts a.gsub(/\S+\s+|\S+$/) { |match| match.sub(/^./) {|firstCh| firstCh.upcase!} }
# the same as above
puts a.gsub(/\b\w/) { |first| first.upcase  }

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

#while gets
#  if /start/../end/
#    puts line 
#  end
#end

#
# The use of Regular(Regexp objects)
#

a = Regexp.new('^\\S*[a-z]')
puts 'Word a'.match(a)
b = /^\S*[a-z]/
puts 'word word' =~ b
c = %r{^\S*[a-z]}
puts ' word word' !~ c

def show_regexp(a, re)
  if a =~ re
    "#{$`}<<#{$&}>>#{$'}"
#    puts "$~.class = #{$~.class}"
#    puts "$~ = #{$~}"
#    puts "$~.inspect = #{$~.inspect}"
  else
    "no match"
  end
end

puts show_regexp('very interesting', /t/)
puts show_regexp('Fats Waller', /a/)
puts show_regexp('Fats Waller', /ll/)
puts show_regexp('Fats Waller', /z/)

a = "The moon is made of cheese"
# \w [a-zA-X0-9_]
# \W [^a-zA-X0-9_]
# r?  == r{0,1}
# ^ $ \A \z \Z \b \B
puts show_regexp(a, /\w+/)
puts show_regexp(a, /\s.*\s/)
puts show_regexp(a, /\s.*?\s/)
puts show_regexp(a, /[aeiou]{2,99}/)
puts show_regexp(a, /mo?o/)

puts show_regexp(a, /d|e/)
puts show_regexp(a, /The|moon/)

puts show_regexp("this is\nthe time", /^the/)
puts show_regexp("this is\nthe time", /is$/)
puts show_regexp("this is\nthe time", /\Athis/)
puts show_regexp("this is\nthe time", /\Athe/)
puts show_regexp("this is\nthe time", /\bis/)
puts show_regexp("this is\nthe time", /\Bis/)

#
# Grouping
#
puts
puts "RegExp grouping"
puts show_regexp('banana', /an*/)
puts show_regexp('banana', /(an)*/)
puts show_regexp('banana', /(an)+/)

a = 'red ball bulue sky'
puts show_regexp(a, /blue|red/)
puts show_regexp(a, /(blue|red) \w+/)
puts show_regexp(a, /red|blue \w+/)

puts show_regexp(a, /red (ball|angry) sky/)
a = 'the red angry sky'
puts show_regexp(a, /red (ball|angry) sky/)

puts "12:50am" =~ /(\d\d):(\d\d)([ap]m)/
puts "Hour is #$1, minite #$2, #$3"
puts "12:50pm" =~ /(\d\d):(\d\d)([ap]m)/
puts "Hour is #$1, minite #$2, #$3"

puts "12:50pm" =~ /((\d\d):(\d\d))([ap]m)/
puts "Time is #$1, hour is #$2, minite is #$3, am/pm is #$4"

# match duplicated letter
puts show_regexp('He said "Hello"', /(\w)\1/)
puts show_regexp('He said "Hello"', /(\w{2}).*\1/)
# match duplicated substrings
puts show_regexp('Mississippi', /(\w+)\1/)

puts "fred:smith".sub(/(\w+):(\w+)/, '\2, \1') 

# Additional backslash sequences
# \& (last match),\+ (lastmatched group), \` (string prior to match), \' (string after match), and \\ (a literalbackslash).
puts
puts 'a\\b\\c'.gsub(/\\/, '\\\\\\\\')
# below two are the same as above
puts 'a\\b\\c'.gsub(/\\/, '\\&\\&')
puts 'a\\b\\c'.gsub(/\\/) { '\\\\' }


