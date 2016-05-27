#Functional, as of 9:02 PM, 5/26/16
#In pry, try:
#list = ShoppingList.new
#Rich = CatPerks.new(1, list)
#Rich.food

#Or just run this file as a ruby file, since I wrote some commands on the bottom

#require "byebug"

class CatPerks
  def initialize(perk_id, shopping_list)
    @id = perk_id.to_i
    @shopping_list = shopping_list
  end

  def method_missing(method_name, *args)
    name = method_name.to_s
    item = ""
    info = ""
    happiness = 0

    if name == "food"
      item = "food"
    elsif name == "toy"
      item = "toy"
    elsif name = silly_outfit
      item = "silly_outfit"
    else
      super
    end

    info = @shopping_list.send("get_#{item}_info", @id)
    happiness = @shopping_list.send("get_#{item}_happiness", @id)

    result = "#{item}: #{info}: #{happiness} purrs!"

    if happiness > 30
      result = "* #{result}"
    end

    return result
  end

  def shopping_list
    p @shopping_list
  end
end

class ShoppingList
  #second number is the happiness in "licks"
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
    type = ""
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

if __FILE__ == $PROGRAM_NAME
  list = ShoppingList.new
  rich = CatPerks.new(1,list)
  puts rich.food
end





#The original stuff
  # def food
  #   info = @shopping_list.get_bone_info(@id)
  #   happiness = @shopping_list.get_bone_happiness(@id)
  #   result = "Bone: #{info}: #{happiness}"
  #   happiness > 30 ? "* #{result}" : result
  # end
  #
  # def kibble
  #   info = @shopping_list.get_kibble_info(@id)
  #   happiness = @shopping_list.get_kibble_happiness(@id)
  #   result = "Kibble: #{info}: #{happiness}"
  #   happiness > 30 ? "* #{result}" : result
  # end
  #
  # def silly_outfit
  #   info = @shopping_list.get_silly_outfit_info(@id)
  #   happiness = @shopping_list.get_silly_outfit_happiness(@id)
  #   result = "Silly Outfit: #{info}: #{happiness}"
  #   happiness > 30 ? "* #{result}" : result
  # end
