# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'main'

class MainTest < Test::Unit::TestCase
  def test_foo
    song1 = Song.new("My Way", "Sinatra", 225)
    song2 = Song.new("Bicylops", "Fleck", 260)

    assert_equal(-1, song1 <=> song2)
    assert_equal(true, song1 < song2)
    assert_equal(false, song1 == song1)
    assert_equal(false, song1 > song2)
  end
end
