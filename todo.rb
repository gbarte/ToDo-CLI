$todo_list = []
$priority = 0

def setup
  puts 'Todo List v0.21'
end

def finished()
  puts 'Bye...'
end

def add_todo(todo)
  if todo == ''
    puts '  :| Nothing to Add - Try \'A todo description\''
  else 
    $todo_list.push [$priority, todo]
  end
end 

def list_todo()
  $todo_list.each.with_index do |todo, index|
      puts "  #{index} (#{todo[0]}) #{todo[1]}"
  end
end

def set_priority(number)
  number = number.to_i
  if number >=0 && number <= 9
    $priority = number
  else
    puts '  :( Priority must be 0 to 9'
  end
end

def increase_priority(index)
  index = index.to_i
  if $todo_list[index][0] == 9
    puts '  :( Priority cannot be higher than 9'
  else
    $todo_list[index][0] += 1
  end
end

def list_todo_from(number)
  number = number.to_i
  $todo_list.each.with_index do |todo, index|
    if todo[0] >= number
        puts "  #{index} (#{todo[0]}) #{todo[1]}"
    end
  end
end

def parse_command(line)
  if line == ''
    puts '  :| Nothing to Add - Try \'A todo description\''
  else
    letter = line[0]
    stripped = line[1..-1].strip
    case letter
    when 'A'
      add_todo(stripped)
    when 'L'
      list_todo()
    when 'P'
      set_priority(stripped)
    when '+'
      increase_priority(stripped)
    when '='
      list_todo_from(stripped)
    else
      puts 'Commands: Q-uit, A-dd. L-ist, H-elp, P-riority'
    end
  end
end

# The main command loop
def main_loop()
  setup()
  finished = false
  while !finished
    print ':)'
    line = gets.chomp
    if line == 'P'
        puts "  Priority is currently #{$priority}"
    elsif line == 'Q'
      finished = true
      finished()
    else
      parse_command(line)
    end
  end
  exit
end
  
main_loop()
