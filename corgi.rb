#Functional, as of 9:02 PM, 5/26/16
#In pry, try:
#list = ShoppingList.new
#Rich = CorgiPerk.new(10, list)
#Rich.bone

class CorgiPerk
  def initialize(perk_id, shopping_list)
    @id = perk_id.to_i
    @shopping_list = shopping_list
  end

  def method_missing(method_name, *args)
    name = method_name.to_s
    item = ""
    info = ""
    happiness = 0

    if name == "bone"
      item = "bone"
    elsif name == "kibble"
      item = "kibble"
    elsif name = silly_outfit
      item = "silly_outfit"
    else
      super
    end

    info = @shopping_list.send("get_#{item}_info", @id)
    happiness = @shopping_list.send("get_#{item}_happiness", @id)

    result = "#{item}: #{info}: #{happiness} licks!"
    happiness > 30 ? "* #{result}" : result

    return happiness
  end

  def shopping_list
    p @shopping_list
  end
end

class ShoppingList
  #second number is the happiness in "licks"
  ITEM_LIST = {
    10 => ["Phoenician rawhide", 40]
  }

  def initialize
    @id = nil
  end

  def method_missing(method_name, perk_id)
    name = method_name.to_s
    item = ""
    @id = perk_id

    raise StandardError("Invalid ID!") unless ITEM_LIST.keys.include?(@id)

    if name.start_with?("get_") && name.length >= 5
      name = name[4..-1]
      if name.start_with?("bone_") && name.length >= 6
        item = "bone"
        name = name[5..-1]
      elsif name.start_with?("kibble_") && name.length >= 8
        item = "kibble"
        name = name[7..-1]
      elsif name.start_with?("silly_outfit_") && name.length >= 14
        item = "silly outfit"
        name = name[14..-1]
      end

      if name == "info"
        return ITEM_LIST[@id][0]
      elsif name == "happiness"
        return ITEM_LIST[@id][1]
      end

    else
      super
    end
  end
end

#The original stuff
  # def bone
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
