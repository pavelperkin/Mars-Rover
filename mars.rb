#  1 - up  2- right  4 - down   8- left
require 'ostruct'

class Position <OpenStruct
end

def get_commands(com_file)
  IO.read(com_file).split
end

def steps route, cur_pos
  route.map {|r|
    cur_pos.course = c_shift_right_1 cur_pos.course if r == 'L' # turn left
    cur_pos.course = c_shift_left_1 cur_pos.course if r == 'R' # turn right
    cur_pos = step cur_pos if r == 'G' # one step
  }
  return cur_pos
end

def step pos
  pos.x += 1 if pos.course == 1 # step right
  pos.y += 1 if pos.course == 2 # step up
  pos.x -= 1 if (pos.course == 8) && (pos.x > 0) # step left  
  pos.y -= 1 if (pos.course == 4) && (pos.y > 0) # step down     
  return pos  
end

def c_shift_right_1(a)
  c= a[0]<<4 #  if a = 00001  then c = 10000   else c = 0000 
  a= a^c # if c =00000 then a=a else a = 10000 
  a= a>>1  # shift a for 1 bit  1 -> 8
end

def c_shift_left_1(a)
  a=a<<1  # shift a for 1 bit left
  a |= a[4] # if a= 10000 then a = 10001 else a=a 
  a &= 15 #  a & 01111  = 0001  8 -> 1 if a = 10001
end

def start( x , y, com_file)
  current_pos=Position.new({:x => x, :y => y, :course => 1})
  route=get_commands (com_file) 
  if (current_pos.x >= 0) && (current_pos.y >= 0) then
    result=steps(route, current_pos)
  else 
    'Position should be positive'
  end
end

#----------------------------   Test   --------------------------------------
require 'minitest/spec'
require 'minitest/autorun'

describe 'start' do
  it 'should return string when x or y is negative' do
    start( -1, 2, 'route.txt').must_equal 'Position should be positive'
    start( 2, -1, 'route.txt').must_equal 'Position should be positive'
    start( -1, -1, 'route.txt').must_equal 'Position should be positive'
  end
  
  it 'should work correct' do
    start( 0, 0, 'route.txt').must_equal Position.new({:x => 0, :y => 0, :course => 1 })
    start(1, 1, 'route.txt').must_equal Position.new({:x => 1, :y => 1, :course => 1 })
    start(1, 1, 'route1.txt').must_equal Position.new({:x => 5, :y => 6, :course => 2 })    
    start(4, 4, 'route2.txt').must_equal Position.new({:x => 4, :y => 0, :course => 4 })    
    start(4, 4, 'route3.txt').must_equal Position.new({:x => 0, :y => 4, :course => 8 })    
  end   
end

describe 'c_shift_left_1' do
  it 'should make cycle shift 4bit-number for one bit left' do
    c_shift_left_1(0).must_equal(0)
    c_shift_left_1(1).must_equal(2)
    c_shift_left_1(8).must_equal(1)
  end
end

describe 'c_shift_right_1' do
  it 'should make cycle shift 4bit-number for one bit right' do
    c_shift_right_1(0).must_equal(0)
    c_shift_right_1(4).must_equal(2)
    c_shift_right_1(1).must_equal(8)
  end
end

describe 'get_commands' do
  it 'should get and parse input file by space' do
    get_commands('test_file.txt').must_equal(['This', 'is', 'a', 'test', 'string'])
  end
end  
