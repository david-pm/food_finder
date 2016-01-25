require 'restaurant'

class Guide

  def initialize(path=nil)
    Restaurant.filepath = path

    if Restaurant.file_usable?
      puts "Found restaurant"
    elsif Restaurant.create_file
      puts "Created restaurant"
    else
      puts `banner -w 30 Exiting`
      exit!
    end
  end

  def launch!
    intro

    # action loop
    result = nil
    until result == :quit
      print "> "
      user_response = gets.chomp
      result = do_action(user_response)
    end

    conclusion
  end

  def do_action(action)
    case action
    when 'list'
      puts 'Listing...'
    when 'find'
      puts 'Finding...'
    when 'add'
      puts 'Adding...'
    when 'quit'
      return :quit
    else
      puts '\nI dont understand that command.\n'
    end
  end

  def intro
    puts "\n\n<<<<< Welcome to the Food Finder >>>>>>\n\n"
    puts `banner -w 30 Food`
  end

  def conclusion
    puts "\n<<<< Goodbye and Bon Appetit! >>>>\n\n"
  end

end
