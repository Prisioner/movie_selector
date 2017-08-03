# Класс user input/output - для работы с консолью
class UserIO
  def output(separator, *some_strings)
    puts some_strings.join(separator)
    puts
  end
  
  def input(some_text = nil)
    puts some_text unless some_text.nil?
    STDIN.gets.chomp
  end
end
