#  1 - up
#  2- right
#  4 - down
#  8- left
require 'ostruct'
class Position <OpenStruct
end

def start_position
puts 'input a start position:'
Position.new({:x => gets.to_i , :y => gets.to_i, :course => 1})
end

def get_commands
 IO.read('route.txt')
end

def parse_commands (s)
  s.split
end

def steps(route, current_pos)
    for i in 0...route.length do
      if route[i]=='L' then
         current_pos.course = c_shift_right_1(current_pos.course)
      end
      if route[i]=='R' then
         current_pos.course = c_shift_left_1(current_pos.course)
      end
      if route[i]=='G' then
        current_pos = step (current_pos)
      end      
    end
    return current_pos
end

def step (position)
    if (position.course == 1) then position.x += 1 end
    if (position.course == 2) then position.y += 1 end
    if (position.course == 8) && (position.x > 0) then position.x -= 1 end
    if (position.course == 4) && (position.y > 0) then position.y -= 1 end    
    return position  
  end

def c_shift_right_1(a)
  c= a[0]<<4
  a= a^c
  a= a>>1  
end

def c_shift_left_1(a)
  a=a<<1
  a |= a[4]
  a &= 15  
end

def start
  current_pos=start_position
  route=parse_commands(get_commands)
  if (current_pos.x >= 0) && (current_pos.y >= 0) then
    puts result=steps(route, current_pos)
  else 
    puts 'Position should be positive'
  end
  gets
end

start