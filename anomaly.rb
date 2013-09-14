#!/usr/bin/env ruby

=begin

  Final Fantasy XIII-2: Clock Anomaly Script
  Copyright (c) 2012 Kunal Mehta
  
  Usage: ruby anomaly.rb X,X,X,X,X,X,X...
  where the Xs are the values of the nodes numbered 0 to n clockwise.
  You can pick 0 arbitrarily.
  
  Output: An array of clock indices to visit in sequence.
  
  This script brute-forces the clock anomaly puzzles found in 
  the temporal rifts around the timeline. Because the script
  maintains a global state during the recursion (versus passing
  copies throughout each step), it could probably handle some 
  really large versions of the puzzle. That said, it's still O(2^n).
  
  04/19/2012 - original
  04/20/2012 - refactoring

  Use of this source code is governed by a BSD license found in README.md.

=end


# GLOBAL STATE

# The clock is represented as an array of pairs of the form [value, active?].
$clock = ARGV[0].split(',').map{|val| [val.to_i, true]}

# The clock hands are a pair of clock indices.
$hands = [0, 0]

# Moves are a simple array of clock indices.
$moves = []


# HELPER FUNCTIONS

# Returns the value of a node.
def value(index)
  $clock[index][0]
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
def lose?
  empty?($hands[0]) and empty?($hands[1])
end

# Updates the clock hands based on a move.
def update_hands(move)
  $hands = [-value(move), value(move)].map{|h| (h + move) % $clock.length} rescue [0,0] # in case the hands revert to initial state
end

# Executes the move and updates state.
def execute(move)
  $moves << move
  $clock[move][1] = false
  update_hands(move)
end

# Reverts state to before the last move.
def revert
  $clock[$moves.pop][1] = true
  update_hands($moves[-1])
end



# The main function of the script.
def do_move(move)
  return if empty?(move)
  execute(move)
  if win?
    puts $moves.inspect
    exit
  elsif lose?
    revert and return
  else
    do_move($hands[0])
    do_move($hands[1])
    revert and return
  end
end

# Try the chain of moves from each starting point.
(0..($clock.length - 1)).each{|start| do_move(start)}
puts 'Unable to find a solution.'

