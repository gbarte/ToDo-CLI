$todo_list = []

def setup
  puts 'Todo List v0.01'
end

def finished()
  puts "Bye..."
end

def add_todo(todo)
  if todo == ''
    puts '  :| Nothing to Add - Try \'A todo description\''
  else
    $todo_list.push [0, todo]
  end
end 

def list_todo()
  $todo_list.each.with_index do |todo, index|
    puts "  #{index}: #{todo}"
  end
end

def parse_command(line)
  letter = line[0]
  stripped = line[1..-1].strip
  case letter
  when 'A'
    add_todo(stripped)
  when 'L'
    list_todo()
  else
    puts 'Commands: Q-uit A-dd L-ist H-elp'
  end
end

# The main command loop
def main_loop()
  setup()
  finished = false
  while !finished
    print ":) "
    line = gets.chomp
    if line == 'X'
      finished = true
    else
      parse_command(line)
    end
  end
  exit
end
  
main_loop()
