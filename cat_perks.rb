#Functional, as of 10:00PM, 5/26/16
#Uncomment some of the bottom portion of the file to run this!

#require "byebug"

class CatPerks
  #invisible: :id and :shopping_list
  attr_accessor :name

  def initialize(perk_id, shopping_list)
    @id = perk_id.to_i
    @shopping_list = shopping_list
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

  # def play
  #   puts "Hello, and welcome to CatPerks! Choose a name for your adorable kitty:"
  #   @name = gets.chomp
  #
  #   puts "You've chosen "
  #
  # end

  def shopping_list
    p @shopping_list
  end
end

class ShoppingList
  #second number is the happiness in "purrs"
  ITEM_LIST = {
    "food" => {1 => ["Catnip", 40]},

    "toy" => {1 => ["Yarnball", 25]},

    "silly outfit" => {1 => ["Hand-knitted sweater", 0]}
  }

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
        return ITEM_LIST[type][@id][1]
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

# if __FILE__ == $PROGRAM_NAME
#   a = ShoppingList.new
#   Rich = CatPerks.new(1, a)
# p  Rich.food
# p  Rich.toy
# p  Rich.silly_outfit
# end

# if __FILE__ == $PROGRAM_NAME
#   CatPerks.play
# end
