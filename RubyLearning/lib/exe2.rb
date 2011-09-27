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
