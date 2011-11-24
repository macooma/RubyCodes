

count = 0
threads = []
10.times do |i|
  threads[i] = Thread.new(i) do |time|
    sleep(time*0.1) 
    Thread.current["mycount"] = count
    count += 1
  end
end
threads.each { |t| t.join; print t["mycount"], ", " }
puts "count = #{count}"

puts "<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>"

#Thread.abort_on_exception=true
threads = []
4.times do |number|
  threads << Thread.new(number) do |i|
    raise "Boom!" if i == 2
    print "#{i}\n"
  end
end
threads.each do |t|
  begin
    t.join
  rescue RuntimeError => e
    puts "Failed: #{e.message}"
  end
end

puts "<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>"

require 'monitor'
class Counter < Monitor
  attr_reader :count
  def initialize
    @count = 0
    super
  end
  def tick
    synchronize do
      @count += 1
    end
  end
end

c = Counter.new
t1 = Thread.new { 10000.times { c.tick  }  }
t2 = Thread.new { 10000.times { c.tick  }  }
t1.join(); t2.join()
puts c.count

# or just include MonitorMixin instead of extends Monitor
# lock = Monitor.new; lock.synchronize {c.tick}
# c.extend(MonitorMixin);...;c.synchronize {c.tick}
puts "<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>"
IO.popen("date") { |io| puts "#{io.gets}" }
