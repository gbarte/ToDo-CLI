# Individual Assignemnt for COM1001
# By Gabriele Barteskaite
# Username: acb18gb

#Declaration of global 
$todo_list = []
#default priority value:
$priority = 0
#smallest and largest possible priority values (as chars for easier testing):
P_MIN = '0'
P_MAX = '9'
#index of priority value in an element of the todo list
INDEX_P = 0
#index of task description in an element of the todo list
INDEX_T = 1

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

def setup
  puts 'Todo List v1.1.1'
  puts 'Type \'H\' to get started'
end

def finished()
  puts 'Bye...'
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
    when 'H'
      help()
    else
      puts 'Commands: Q-uit, H-elp, A-dd, L-ist, P-riority, D-elete, T-idy'
    end
  end
end

# Adding new elements to list
def add_todo(task)
  if task == ''
    puts '  :| Nothing to Add - Try \'A todo description\''
  elsif $todo_list.length == 0
    #if first list element
    $todo_list.push [$priority, task]
  else
    #finding the right place for new task
    $todo_list.each.with_index do |todo, index|
      if todo[INDEX_P] < $priority
        $todo_list.insert(index, [$priority, task])
        break
      #tasks of same priority listed from the one added first to last
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

# Printing the list
def list_todo(find)
  if $todo_list.length == 0
    puts '  :| You haven\'t created a list yet - Try \'A todo description\''
  elsif find.length > 0
      #if there is anything after the letter L proceed to
      find_todo(find)
  else
    $todo_list.each.with_index do |todo, index|
      puts "  #{index} (#{todo[INDEX_P]}) #{todo[INDEX_T]}"
    end
  end
end

# List only todos that have <find> within them
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

# Setting a new value of priority
def set_priority(input)
  if input == ""
    show_priority()
  # changing value only if new value is within bounds
  elsif input.between?(P_MIN,P_MAX) && input.length == 1
    number = input.to_i
    $priority = number
  else
    puts '  :( Priority must be 0 to 9'
  end
end

# Printing priority value
def show_priority()
  puts "  Priority is currently #{$priority}"
end

# Increasing priority by 1 at specified index
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

# List all todos with specified priority and higher 
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

# Deleting list item at specified index
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

# Removing repetitive todos
def tidy_todo()
  if $todo_list.length == 0
      puts 'There is no list to tidy - Try \'A todo description\''
  else
    i = 0
    while i < $todo_list.length
      j = i + 1
      while j < $todo_list.length
        if $todo_list[i][INDEX_T].upcase == $todo_list[j][INDEX_T].upcase \
          && $todo_list[i][INDEX_P] >= $todo_list[j][INDEX_P]
            delete_todo(j.to_s)
            # decreasing j because of the index shift in the array
            j -= 1
        end
        j += 1
      end
      i += 1
    end
  end
end

def help()
  puts '  Welcome!'
  puts '  This is a program for making a todo list'
  puts '  Start by adding a task to your list by typing \'A <todo description>\' '
  puts '  To view your todo list type \'L\' '
  puts '  \'L <find>\' lists only todos which have the text <find> in them'
  puts '  The default priority value for your tasks is 0'
  puts '  To change it type \'P <value from 0 to 9>\' '
  puts '  To increase the priority value of a task that is already on the list by 1 type \'+ <index>\' '
  puts '  To view only the tasks of a chosen priority or higher type \'= <value>\' '
  puts '  To delete a task from the list type \'D <index_of_task>\' '
  puts '  Type \'T\' to tidy your code from tasks with duplicate descriptions'\
       ' (the task with higher priority will be kept)'
  puts '  To view this help message again type \'H\' '
  puts '  \'Q\' quits the application'
end

main_loop()
