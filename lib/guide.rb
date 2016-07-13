require 'restaurant'

class Guide
  class Config
    @@actions = %w[list find add exit clear]
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
    clear_screen_type
  end

  def clear_screen_type
    if Gem.win_platform? 
      def clear_screen!; (system "cls"); end
    else
      def clear_screen!; (system "clear"); end
    end
  end

  def launch!
    output_salutations " Welcome to the Food Finder "
    puts "Type: 'list', 'find', 'add' or 'exit' to continue\n".center(60)

    # action loop
    result = nil
    until result == :exit
      action, args = get_action
      result = do_action(action, args)
      if result == :clear
        clear_screen!
      end
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
      list(args)
    when "find"
      keyword = args.shift
      find(keyword)
    when "add"
      add
    when "exit"
      return :exit
    when "clear"
      return :clear
    else # safety net
      puts "\nI dont understand that weird command.\n"
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

  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order = "name" unless ["name", "cuisine"].include?(sort_order)

    output_action_header("restaurants")
    restaurants = Restaurant.saved_restaurants

    restaurants.sort! do |r1, r2|
      case sort_order
      when 'name'
        r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
        r1.cuisine.downcase <=> r2.cuisine.downcase
      end
    end

    output_restaurant_table(restaurants)
    puts "Sort using: 'list name'\n\n"
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
