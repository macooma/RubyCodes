p [3,1,7,0].sort.reverse
# When an assignment has more than one lvalue,the assignment expression returns an array of the rvalues.
# If an assignment contains more lvalues than rvalues, the excess lvalues are set to nil.
# If a multiple assignment contains more rvalues than lvalues, the extra rvalues are ignored. 
# If an assignment has just one lvalue and multiple rvalues, the rvalues are converted to an array
# and assigned to the lvalue.
file = File.open("rangetest")
while line = file.gets
  puts(line) if line =~ /third/ .. line =~ /fifth/
end
puts "<<<<<<<<<<<<<<<<"
IO.foreach("rangetest") do |line|
  if(($. == 1)|| line =~ /eig/)..(($. == 3) || line =~ /nin/)
    print line
  end
end

str = IO.read("rangetest")
puts str.dump

arr = IO.readlines("rangetest")
p arr

begin
  err_str = IO.read("error")
  p err_str
rescue StandardError => error
  puts error.message
ensure
  puts "finish operations"
end

puts "<<<<<<<<<<<<<<>>>>>>>>>>>>>>"
require 'stringio'
ip = StringIO.new("new is\nthe time\nto learn\nRuby!")
op = StringIO.new("", "w");
ip.each_line do |line|
  op.puts line.reverse
end
puts op.string.dump

# behind-the-scenes magic behaviors:
# gets assigns the last line read to the global variable $_,
# the ~ operator does a regular expression match against $_,
# print with no arguments prints $_.
# the variable $. contains the current input line number
# Ruby places a reference to the associated Exception object into the global variable $!
# load path $:
# Ruby keeps a list of the files loaded by require in the array $".
# you’ll find the subprocess’s exit code in the global variable $?.
# $? is a global variable that contains information on the termination of a subprocess