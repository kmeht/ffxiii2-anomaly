=begin

  Final Fantasy XIII-2: Clock Anomaly Script
  by Kunal Mehta
  
  Usage: ruby finalfantasyxiii2_anomaly.rb X,X,X,X,X,X,X...
  where the Xs are the values of the nodes numbered 0 to n clockwise.
  You can pick 0 arbitrarily.
  
  This script brute-forces the clock anomaly puzzles found in 
  the temporal rifts around the timeline. Because the script
  maintains a global state during the recursion (versus passing a 
  copy of the state throughout each step), it could probably handle 
  some really large versions of the puzzle.
  
  04/19/2012 - original
  04/20/2012 - initial cleanup, command-line argument
  
=end

# GLOBAL STATE

# The clock is represented as an array of pairs of the form [value, active?].
$clock = ARGV[0].split(",").map{|val| [val.to_i, true]}

# Moves are represented by a simple array of clock indices.
$moves = []

# The clock hands are a pair of indices.
$hands = [0, 0]


# HELPER FUNCTIONS

# Returns the value of a node.
def value(index)
  $clock[index][0]
end

def upper(start)
  (start + value(start)) % $clock.length
end

def lower(start)
  (start - value(start)) % $clock.length
end

# Checks if a node is empty.
def empty?(index)
  not $clock[index][1]
end

# Checks if every node is empty.
def win?
  $clock.find_all{|node| node[1]}.empty?
end

# Checks if both clock hands point to empty nodes.
def lose?(hand1, hand2)
  empty?(hand1) and empty?(hand2)
end

# Updates the clock hands based on a move.
def update_hands(move)
  $hands = [-value(move), value(move)].map{|h| (h + move) % $clock.length}
  $hands = [(move - value(move)) % $clock.length, (move + value(move)) % $clock.length]
end

# Executes the move, updates state, and returns the new positions of the clock hands.
def execute(move)
  $moves << move
  $clock[move][1] = false
end

# Reverts the state to before the last move.
def revert
  $clock[$moves.pop][1] = true
end


# RECURSIVE FUNCTION

def do_move(move)
  return if empty?(move)
  h1 = lower(move)
  h2 = upper(move)
  execute(move)
  if win?
    puts $moves.inspect
    exit
  elsif lose?(h1, h2)
    revert and return
  else
    do_move(h1)
    do_move(h2)
    revert and return
  end
end


# EXECUTION

(0..($clock.length - 1)).each{|start| do_move(start)}

