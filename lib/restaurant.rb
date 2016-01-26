class Restaurant
  attr_accessor :name, :cuisine, :price
  @@filepath = nil

  def initialize(args = {})
    # todo: validate args
    @name    = args[:name]    || ""
    @cuisine = args[:cuisine] || ""
    @price   = args[:price]   || ""
  end

  # class setter
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  def self.file_exists?
    if @@filepath && File.exists?(@@filepath)
      return true
    else
      return false
    end
  end

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    File.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end

  def self.saved_restaurants
    # deliberately fetching fresh copy each time
    restaurants = []
    if file_usable?
      file = File.new(@@filepath, 'r')
      file.each_line do |line|

        restaurants << Restaurant.new.import_line(line.chomp)
      end
      file.close
    end
    return restaurants
  end

  def self.build_using_questions
    args = {}
    print "Restaurant name: "
    args[:name] = gets.chomp.strip
    print "Cuisine type: "
    args[:cuisine] = gets.chomp.strip
    print "Average price (out of $$$$$): "
    args[:price] = gets.chomp.strip

    return self.new args
  end

  def import_line(line)
    line_arr = line.split("\t")
    @name, @cuisine, @price = line_arr # triple assignment
    return self
  end

  def save
    return false unless Restaurant.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
    end
    return true
  end

end
