require 'restaurant'

class Guide
  class Config
    @@actions = %w[list find add quit]
    def self.actions; @@actions; end
  end

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
      action = get_action
      result = do_action(action)
    end

    conclusion
  end

  def get_action
    action = nil
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      action = user_response.downcase.strip
    end
    return action
  end

  def do_action(action)
    case action
    when "list"
      list
    when "find"
      puts "Finding..."
    when "add"
      add
    when "quit"
      return :quit
    else # safety net
      puts "\nI dont understand that command.\n"
    end
  end

  def list
    puts "\nListing a restaurant\n\n".capitalize

    restaurants = Restaurant.saved_restaurants
    restaurants.each do |r|
      puts r.name + " | " + r.cuisine + " | " + r.price
    end
  end

  def add
    puts "\nAdd a restaurant\n\n".capitalize

    restaurant = Restaurant.build_using_questions

    if restaurant.save
      puts "\nRestaurant Added\n\n"
    else
      puts "\nSave Error: restaurant not added\n\n"
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
