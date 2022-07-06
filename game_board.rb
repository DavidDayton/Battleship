class GameBoard
    # @max_row is an `Integer`
    # @max_column is an `Integer`
    attr_reader :max_row, :max_column, :ship_array, :successful_attacks

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        @ship_array = Array.new
        @successful_attacks = 0
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
p "Ship: Starting pos: #{ship.start_position} Orientation: #{ship.orientation} size: #{ship.size}"
        positions = Array.new
        hit_positions = Array.new
        is_ship_sunk = false # num of hit positions is == to the size of the ship then true
        fill_positions(ship, positions) 
p "Ship Positions: #{positions}"
        if can_ship_be_added?(ship, positions) == true then
            @ship_array.push([ship, positions, hit_positions, is_ship_sunk]) # add ship to board 
p "Ship Added: #{@ship_array.size}"
#@ship_array.each {|boop| p "#{boop[1]}" }      
            return true
        end
p "NOT Added"
        return false
    end

    # fills the positions array with the positions of the ship passed in
    def fill_positions(ship, positions)
        
        x = 1 # loop variable
        current_column = ship.start_position.column
        current_row = ship.start_position.row
        positions.push(ship.start_position) # add starting positions

        # add the rest of the positions based on orientation
        case ship.orientation
        when "Up" then # changes the row value negativly 
            while x < ship.size
                current_row -= 1
                positions.push(Position.new(current_row, current_column))
                x += 1
            end
        when "Down" then # changes the row value positivly
            while x < ship.size
                current_row += 1
                positions.push(Position.new(current_row, current_column))
                x += 1
            end
        when "Left" then # changes the column value negativly
            while x < ship.size
                current_column -= 1
                positions.push(Position.new(current_row, current_column))
                x += 1
            end
        when "Right" then # changes the column value positivly
            while x < ship.size
                current_column += 1
                positions.push(Position.new(current_row, current_column))
                x += 1
            end
        end
    end

    # Check if a ship can be added to the game board
    # returns a boolean 
    def can_ship_be_added?(ship, positions)

        # check if the ship is not nil 
        if !ship then
            return false
        end

        # check if the ship is with the game board boundaries
        if is_ship_within_boundaries?(ship) == false then
p "not in boundaries"
            return false
        end

        # check if there is an overlapping ship
        if is_ship_in_way?(ship, positions) == true then
p "overlapping"
            return false
        end

        #if @ship_array.size == 5 then
        #    return false
        #end

        # ship can be added if it has gotten to this point
        return true

    end

    # Check if a ship we is within the set boundaries of the board.
    # returns a true when inside boundaries, else false
    def is_ship_within_boundaries?(ship)
        


        # check if the starting position is within the the boundaries
        if ship.start_position.row > @max_row || 
           ship.start_position.row < 1 || 
           ship.start_position.column > @max_column || 
           ship.start_position.column < 1 
        then
p "first conditional (is within boundaries)"
            return false
       end

       # check if it is within the bounds based on the orientation and size of the ship
       case ship.orientation
       when "Up" then # changes the row value negativly 
            if ship.start_position.row - (ship.size - 1) < 1 then
#p "Up is wrong"
                return false
            end
       when "Down" then # changes the row value positivly
            if ship.start_position.row + (ship.size - 1) > @max_row then
# p "down is wrong"
                return false
            end
       when "Left" then # changes the column value negativly
            if ship.start_position.column - (ship.size - 1) < 1 then
#p "left is wrong"
                return false
            end
       when "Right" then # changes the column value positivly
            if ship.start_position.column + (ship.size - 1) > @max_column then
# p "right is wrong"
                return false
            end
        else
p "not valid orientation"
            return false # orientation is not a valid word
       end

       # passed all tests so it is within boundaries
       return true

    end

    # checks to see if the ship we want to add will be overlapping with another
    # returns true if a ship is in the way, else false
    # assumes the ship returns true to valid?
    def is_ship_in_way?(ship, positions)

        x = 0 # loop var

        # Go through each ship on the board and check if this one will overlap with that one
        @ship_array.each do |added_ship| # getting each ship
            added_ship[1].each do |added_ship_position| # positions array of the added ship
                positions.each do |ship_position| # positions array of the "new" ship
                    # check if any of the positions are the same
                    if ship_position.row == added_ship_position.row &&
                       ship_position.column == added_ship_position.column
                    then
                        return true
                    end    
                end
            end
        end
        return false
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        already_hit = false # a bool to keep track if we already hit this location
p "shot at: #{position}"

        #check if attack pos is within boundaries
        if position.row > @max_row || 
           position.row < 1 || 
           position.column > @max_column || 
           position.column < 1 
        then
p "Shot was out of bounds"
            return nil
        end

        # check position
        @ship_array.each do |ship| # getting each ship
p "Ship: Starting pos: #{ship[0].start_position} Orientation: #{ship[0].orientation} size: #{ship[0].size}" 
            ship[1].each do |ship_position| # positions array of all ships
                if ship_position.row == position.row &&
                   ship_position.column == position.column
                 then
                     # A ship is in this location
                     # Now check if we alredy hit this location
                     ship[2].each do |hit_positions| 
                        if hit_positions.row == position.row &&
                           hit_positions.column == position.column
                        then
p "We already hit there!"
                            already_hit = true
                        end
                     end
                     if already_hit == false then # if we havn't hit there...
                        # Add the hit position to the array of hit positions each ship has 
                        ship[2].push(position) 
                        @successful_attacks += 1 # increment the # of successful attacks
p "Hit!"
                        # Check if the ship is sunk
                        # if # of hit positions is == size of the ship then the ship is sunk
                        if ship[2].size == ship[0].size then
p "SUNK!"
                            ship[3] = true
                        end
                        return true
                     end
                 end   
            end
        end
p "Num of Hits: #{@successful_attacks}"
p "NOT HIT"
        return false
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
p "Num of Hits from function: #{@successful_attacks}"
        return @successful_attacks
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        @ship_array.each do |ship| # getting each ship
            # if a ship is not sunk then return false
            if ship[3] == false then
                return false
            end
        end
        return true 
    end

    # String representation of GameBoard (optional but recommended)
    def to_s
        "STRING METHOD IS NOT IMPLEMENTED"
    end
end
