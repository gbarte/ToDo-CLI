$todo_list = []

#default priority value:
$priority = 0

#smallest and largest possible priority values (as chars for easier testing):
P_MIN = '0'
P_MAX = '9'

#index of priority value in an element of the todo list
INDEX_P = 0;
#index of task description in an element of the todo list
INDEX_T = 1;

def setup
  puts 'Todo List v0.07'
end

def finished()
  puts 'Bye...'
end

def add_todo(task)
  if task == ''
    puts '  :| Nothing to Add - Try \'A todo description\''
  elsif $todo_list.length == 0
    $todo_list.push [$priority, task]
  else
    $todo_list.each.with_index do |todo, index|
      if todo[INDEX_P] < $priority
        $todo_list.insert(index, [$priority, task])
        break
      elsif $todo_list[index][INDEX_P] == $priority
        if index+1 == $todo_list.length
          $todo_list.push [$priority, task]
          break
        elsif $todo_list[index+1][INDEX_P] < $priority
          $todo_list.insert(index+1, [$priority, task])
          break
        end
      end
    end
  end
end 

def list_todo(find)
  if $todo_list.length == 0
    puts '  :| You haven\'t created a list yet - Try \'A todo description\''
  elsif find.length > 0
      find_todo(find)
  else
    $todo_list.each.with_index do |todo, index|
      puts "  #{index} (#{todo[INDEX_P]}) #{todo[INDEX_T]}"
    end
  end
end

def show_priority()
  puts "  Priority is currently #{$priority}"
end

def set_priority(input)
  if input == ""
    show_priority()
  elsif input.between?(P_MIN,P_MAX) && input.length == 1
    number = input.to_i
    $priority = number
  else 
    puts '  :( Priority must be 0 to 9'
  end
end

def increase_priority(input)
  index = input.to_i
  if index == 0 && input != "0"
    puts '  :( The index of a task is a number'
  elsif !index.between?(0,$todo_list.length-1)
    puts '  :( There is no task with such index'
  elsif $todo_list[index][INDEX_P] == P_MAX.to_i
    puts '  :( Priority cannot be higher than 9'
  else
    $todo_list[index][INDEX_P] += 1
  end
end

def list_todo_from(input)
  if $todo_list.length == 0
    puts '  :| You haven\'t created a list yet - Try \'A todo description\''
  elsif input.between?(P_MIN,P_MAX) && input.length == 1
    number = input.to_i
    $todo_list.each.with_index do |todo, index|
      if todo[INDEX_P] >= number
        puts "  #{index} (#{todo[INDEX_P]}) #{todo[INDEX_T]}"
      end 
    end
  else 
    puts '  :( Priority values are from 0 to 9'
  end
end

def delete_todo(input)
  index = input.to_i
  if index == 0 && input != "0"
    puts '  :( The index of a task is a number'
  elsif !index.between?(0,$todo_list.length-1)
    puts '  :( There is no task with such index'
  else
    $todo_list.delete_at(index)
    puts "List item at index #{index} deleted"
  end
end

def find_todo(find)
  found = 0
  $todo_list.each.with_index do |todo, index|
    if todo[INDEX_T].upcase[find.upcase]
      puts "  #{index} (#{todo[INDEX_P]}) #{todo[INDEX_T]}"
      found += 1
    end 
  end
  if found == 0
    puts '  :| No matching Todos'
  end
end

def tidy_todo()
  if $todo_list.length == 0
      puts 'There is no list to tidy - Try \'A todo description\''
  else
    i = 0
    while i < $todo_list.length
      j = i + 1
      while j < $todo_list.length
        if $todo_list[i][INDEX_T].upcase == $todo_list[j][INDEX_T].upcase
          if $todo_list[i][INDEX_P] >= $todo_list[j][INDEX_P]
            delete_todo(j.to_s)
            j -= 1
          end
        end
        j += 1
      end
      i += 1
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
      list_todo(stripped)
    when 'P'
      set_priority(stripped)
    when '+'
      increase_priority(stripped)
    when '='
      list_todo_from(stripped)
    when 'D'
      delete_todo(stripped)
    when 'T'
      tidy_todo()
    else
      puts 'Commands: Q-uit, A-dd. L-ist, H-elp, P-riority, D-elete'
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
    if line == 'Q'
      finished = true
      finished()
    else
      parse_command(line)
    end
  end
  exit
end
  
main_loop()
