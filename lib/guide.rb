require 'restaurant'

class Guide
  class Config
    @@actions = %w[list find add quit]
    def self.actions; @@actions; end
  end

  def initialize(path=nil)
    Restaurant.filepath = path

    if Restaurant.file_usable?
      puts "Found restaurant\n\n"
    elsif Restaurant.create_file
      puts "Created restaurant\n\n"
    else
      puts `banner -w 30 Exiting`
      exit!
    end
  end

  def launch!
    output_salutations " Welcome to the Food Finder "

    # action loop
    result = nil
    until result == :quit
      action, args = get_action
      result = do_action(action, args)
    end

    output_salutations " Goodbye and Bon Appetit! "
  end

  def get_action
    action = nil
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.split(" ")
      action = args.shift # remove args[0]
    end
    return [action, args]
  end

  def do_action(action, args = [])
    case action
    when "list"
      list
    when "find"
      keyword = args.shift
      find(keyword)
    when "add"
      add
    when "quit"
      return :quit
    else # safety net
      puts "\nI dont understand that command.\n"
    end
  end

  def find(keyword="")
    output_action_header("find a restaurant")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |r|
        r.name.downcase.include?(keyword.downcase) ||
        r.cuisine.downcase.include?(keyword.downcase)
      end
      output_restaurant_table(found)
    else
      puts "Try 'find' then a cuisne type or restaurant name. "
    end
  end

  def list
    output_action_header("restaurants")
    restaurants = Restaurant.saved_restaurants

    output_restaurant_table(restaurants)
  end

  def add
    output_action_header("add a restaurant")
    restaurant = Restaurant.build_using_questions

    if restaurant.save
      puts "\nRestaurant Added\n\n"
    else
      puts "\nSave Error: restaurant not added\n\n"
    end
  end

  private

    def output_salutations(text)
      puts "\n#{text.upcase.center(60, '*')}\n\n"
    end

    def output_action_header(text)
      puts "\n#{text.upcase.center(60)}\n\n"
    end

    def output_restaurant_table(restaurants=[])
      print " " + "Name".ljust(30)
      print " " + "Cuisine".ljust(20)
      print " " + "Price".ljust(6) + "\n"
      puts "-" * 60
      restaurants.each do |r|
        line =  " " << r.name.ljust(30)
        line << " " +  r.cuisine.ljust(20)
        line << " " +  r.price.ljust(6)
        puts line
      end
      puts "No listings found" if restaurants.empty?
      puts "-" * 60
    end

end
