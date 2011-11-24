class Song
    attr_reader :name, :artist, :duration
    # the same as: 
    # def name 
    #     @name
    # end
    #
    
    attr_writer :name, :artist, :duration
    # the same as:
    # def duration=(_duration)
    #     @duration = _duration
    # end
    #
    include Comparable
    def initialize(name, artist, duration)
        @name = name
        @artist = artist
        @duration = duration
    end
    
    def <=> (other) 
      self.duration <=> other.duration
    end
    
    def to_s
        "Song:#@name--#@artist(#@duration)"
    end
end

class KaraokeSong < Song
    def initialize(name,artist,duration,lyrics)
        super(name,artist,duration)
        @lyrics = lyrics
    end
    
    def to_s
        super.to_s + "[#@lyrics]"
    end
end

class WordIndex
  def initialize
    @index = {}
  end
  
  def add_to_index(obj, *phrases)
    phrases.each do |phrase|
      phrase.scan(/\w[-\w']+/) do |word|
        word.downcase!
        @index[word] = [] if @index[word].nil?
        @index[word].push(obj)
      end
    end
  end
  
  def lookup(word)
    @index[word.downcase]
  end
end

class SongList
    def initialize
        @songs = Array.new
        @index = WordIndex.new
    end
    def append(song)
        @songs.push(song)
        @index.add_to_index(song, song.name, song.artist)
        self
    end
    def delete_first
        @songs.shift
    end
    def delete_last
        @songs.pop
    end
    def [](index)
        @songs[index]
    end
    def with_title(title)
      @songs.find {|song| title == song.name}
    end
    def lookup(word)
      @index.lookup(word)
    end
end

# require 'test/unit'
# class TestSongList < Test::Unit::TestCase
#     def test_delete
#         list = SongList.new
#         s1 = Song.new('title1', 'artist1', 1)
#         s2 = Song.new('title2', 'artist2', 2)
#         s3 = Song.new('title3', 'artist3', 3)
#         s4 = Song.new('title4', 'artist4', 4)
#         list.append(s1).append(s2).append(s3).append(s4)
#         assert_equal(s1, list[0])
#         assert_equal(s3, list[2])
#         assert_nil(list[9])
#         assert_equal(s1, list.delete_first)
#         assert_equal(s2, list.delete_first)
#         assert_equal(s4, list.delete_last)
#         assert_equal(s3, list.delete_last)
#         assert_nil(list.delete_last)
#     end
# end

#File.open("./songdata") do |song_file|
#  songs = SongList.new
#  song_file.each do |line|
#    file, length, name, title = line.chomp.split(/\s*\|\s*/)
#    name.squeeze!(" ")
#    mins, secs = length.split(/:/)
#    # the same as above: mins, secs = length.scan(/\d+/)
#    song = Song.new(title, name, mins.to_i*60 + secs.to_i)
#    songs.append(song)
#    puts song 
#  end
#  p songs
#  puts "Search result:"
#  puts songs.lookup("ain't")
#  puts songs.lookup("RED")
#  puts songs.lookup("WoRlD")
#end
