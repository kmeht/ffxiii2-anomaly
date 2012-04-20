
$grid = [3, 4, 6, 4, 3, 3, 5, 2, 2, 1, 2, 5].map{|e| [e, true]}
$moves = []

# HELPER METHODS
def value(index)
  $grid[index][0]
end

def upper(start)
  (start + value(start)) % $grid.length
end

def lower(start)
  (start - value(start)) % $grid.length
end

def empty?(index)
  not $grid[index][1]
end

def win?
  for square in $grid
    return false if square[1]
  end
  return true
end

def lose?(lower, upper)
  (not $grid[lower][1]) and (not $grid[upper][1])
end

# Executes the move
def change_state(move)
  $moves << move
  $grid[move][1] = false
end

# Reverts the move
def revert_state
  $grid[$moves.pop][1] = true
end


# ACTUAL METHODS

def do_move(move)
  #puts $grid.inspect
  #puts "About to do index #{move}."
  if empty?(move)
    return nil
  else
    h1 = lower(move)
    h2 = upper(move)
    #puts "Choices are indices #{h1} and #{h2}."
    #puts "Upper for move #{move} with value #{$grid[move][0]}: #{h1}"
    #puts "Lower for move #{move} with value #{$grid[move][0]}: #{h2}"
    change_state(move)
    if win?
      puts "You won!"
      puts $moves.inspect
      return true
    elsif lose?(h1, h2)
      #puts "You lost. :("
      revert_state
      return nil
    else
      deeper = do_move(h1) or do_move(h2)
      revert_state if deeper.nil?
      return deeper
    end
  end
end

(0..($grid.length - 1)).each do |start|
  print $moves unless do_move(start).nil?
end

