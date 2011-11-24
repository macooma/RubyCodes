require 'profile'
count = 0
words = File.open("rangetest")
while word = words.gets
  word = word.chomp!
  if word.length >= 10
    count += 1
  end
end

puts "#{count} more-than-10-character words"

#require 'profile'
#words = File.read("rangetest")
#count = words.scan(PATT = /^..........(.*)\n/).size
#puts "#{count} more-than-10-character words"

p ENV['USERNAME']