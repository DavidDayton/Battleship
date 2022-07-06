require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
    board = GameBoard.new 10, 10
    # the regex to get the structure but not necessarily the correct digits
    regex = /^(\(\d{1,2},\d{1,2}\)), (\w+), ([1-5])$/ 

    read_file_lines(path) do |line|  
p line
        if line =~ regex then
            positiion_string = $1 # get the position nums from the line
            orientation = $2 # get the orientation
            size = $3.to_i # get the size which should be 1-5 based on regex
            positiion_array = positiion_string.scan(/\d+/) # get the nums from the string
            # Create the starting position
            starting_position = Position.new(positiion_array[0].to_i, positiion_array[1].to_i)
            #p "starting pos: #{starting_position}" 
            #p starting_position  
            #p orientation
            #p size

            #p "how many ships???? #{board.ship_array.size}"
            # if the board has less than 6 ships try to add one
            if board.ship_array.size == 5 then
p "how many ships! #{board.ship_array.size}"
               return board
            end

            # Create a new ship then add it to the board
            new_ship = Ship.new(starting_position, orientation, size)
            board.add_ship(new_ship)
        end
    end

    if board.ship_array.size == 5 then
        #p "how many ships! #{board.ship_array.size}"
        #p "About to return!"
        #p " "
        #p " "
        return board
    end

p "Returned nil"
    return nil
end


# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    attack_positions = Array.new
    # The regex to get (x,y) type string out of the file (x and y being a num 1-10)
    regex = /(^\(\d{1,2},\d{1,2}\)$)/

    # Loop through the lines in the file
    file_exists = read_file_lines(path) do |line|  
p line
        if line =~ regex then
            # get the position nums from the line
            positiion_string = $1 
            # get the nums from the string (it gets put in an array)
            positiion_array = positiion_string.scan(/\d+/) 
            # Create the starting position
            attack_positions.push(Position.new(positiion_array[0].to_i, positiion_array[1].to_i))
p "attack_positions: #{attack_positions}"
        end
    end
    
    if file_exists then 
        return attack_positions
    end

    return nil
end


# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end
