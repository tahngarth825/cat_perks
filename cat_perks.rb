#Functional, as of 10:48 PM, 5/26/16

#require "byebug"

class CatPerks
  #invisible: :id and :shopping_list
  attr_accessor :name, :breed

  def initialize
    @shopping_list = ShoppingList.new
  end

  def method_missing(method_name, *args)
    name = method_name.to_s

    if name == "food"
      item = "food"
    elsif name == "toy"
      item = "toy"
    elsif name == "silly_outfit"
      item = "silly_outfit"
    else
      super
    end

    info = @shopping_list.send("get_#{item}_info", @id)
    happiness = @shopping_list.send("get_#{item}_happiness", @id)

    result = "#{item}: #{info}: #{happiness} purrs!"

    if happiness > 30
      result = "Wonderful #{result}!!"
    end

    return result
  end

  def play
    puts "Hello, and welcome to CatPerks! Choose a name for your adorable kitty:"
    @name = gets.chomp

    puts "You've chosen #{@name} to be the name of your cat. Wonderful!"
    puts "What breed of cat woudld you like?"
    @breed = gets.chomp

    puts "Wonderful! We've found a #{@breed} here at the pound just for you!"
    puts "We've crafted a name-tag for your cat!"
    puts "*Hands over #{@name}*"

    indicator = false
    until indicator
      shop
      indicator = true
    end

    puts "#{name} is going to sleep. Goodnight!"
  end

  def shop
    puts "Let's go shopping! Here are the items available at the store:"
    shopping_list.each do |item_num, item, price|
      puts "We have item number #{item_num}: #{item} available at $#{price}."
    end

    puts "What would you like to purchase?"
    #in progress
  end

  def shopping_list
    @shopping_list.items_and_prices
  end
end

class ShoppingList
  #first number is item number, second number is how much purrs it's worth,
  #and third number is price
  ITEM_LIST = {
    "food" => {1 => ["Catnip", 100, 40]},

    "toy" => {1 => ["Yarnball", 50, 25]},

    "silly outfit" => {1 => ["Hand-knitted sweater", 25, 0]}
  }

  def items_and_prices
    items = []
    #amount of purrs given is intentionally hidden
    ITEM_LIST.keys.each do |key|
      ITEM_LIST[key].keys.each do |item_num|
        info = ITEM_LIST[key][item_num]
        items << ([item_num] + info[0..1])
      end
    end
    return items
  end

  def initialize
    @id = nil
  end

  def method_missing(method_name, perk_id)
    name = method_name.to_s
    @id = perk_id

    raise StandardError("Invalid ID!") unless valid_id?

    if name.start_with?("get_") && name.length >= 5
      name = name[4..-1]
      if name.start_with?("food_") && name.length >= 6
        type = "food"
        name = name[5..-1]
      elsif name.start_with?("toy_") && name.length >= 5
        type = "toy"
        name = name[4..-1]
      elsif name.start_with?("silly_outfit_") && name.length >= 14
        type = "silly outfit"
        name = name[13..-1]
      end

      if name == "info"
        return ITEM_LIST[type][@id][0]
      elsif name == "happiness"
        return ITEM_LIST[type][@id][2]
      end

    else
      super
    end
  end

  def valid_id?
    all_keys = ITEM_LIST.keys

    all_keys.each do |type|
      ITEM_LIST[type].keys.each do |item_id|
        return true if @id == item_id
      end
    end

    return false
  end
end

if __FILE__ == $PROGRAM_NAME
  new_game = CatPerks.new
  new_game.play
end
