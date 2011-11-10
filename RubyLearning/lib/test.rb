require "./main.rb"
song1 = Song.new("My Way", "Sinatra", 225)
song2 = Song.new("Bicylops", "Fleck", 260)

puts song1 <=> song2
puts song1 < song2
puts song1 == song1
puts song1 > song2
