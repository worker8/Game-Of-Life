class Board
  Width = 40
  Height = 20

  attr_accessor :cell_map

  def initialize
    @cell_map = Array.new Height
    print @cell_map.class,"\n"
    @cell_map.map! {|t|
      row = Array.new Width
      row.map! {|r|
      Cell.new(:dead)
      }
    }
  end

  def setXYto(row,col,live_or_dead)
    @cell_map[row][col].live_state = live_or_dead
  end

  def start_game
    count = 0
    while true do
      print_map
      print count
      count +=1
      sleep(1);
      update_cell_state
      clear_map
    end
  end

  def update_cell_state
    @cell_map.each_with_index {|row,r_index|
      row.each_with_index{|col,c_index|
        col.calc_next_state(get_number_of_neighbours_for_cell_at(r_index,c_index))
      }
    }
    @cell_map.each_with_index {|row,r_index|
      row.each_with_index{|col,c_index|
        col.enforce_next_state
      }
    }

  end

  def clear_map
    system('clear')
    #total_CR = Width * Height + 1
    #total_CR.times {
    #print "\r"
    #}
  end

  def print_map
    @cell_map.each { |row|
      row.each {|col|
        col.cell_print
      }
      puts ''
    }
    nil
  end

  def get_number_of_neighbours_for_cell_at(row,col)
    counter = 0
    if (row == 0)
      if (col == 0)
        counter += (@cell_map[row][col+1].is_alive?)? 1 : 0

        counter += (@cell_map[row+1][col].is_alive?)? 1 : 0
        counter += (@cell_map[row+1][col+1].is_alive?)? 1 : 0
      elsif(col == Width-1)
        counter += (@cell_map[row][col-1].is_alive?)? 1 : 0
        counter += (@cell_map[row+1][col-1].is_alive?)? 1 : 0
        counter += (@cell_map[row+1][col].is_alive?)? 1 : 0
      else
        counter += (@cell_map[row][col-1].is_alive?)? 1 : 0
        #counter += (@cell_map[row][col].is_alive?)? 1 : 0
        counter += (@cell_map[row][col+1].is_alive?)? 1 : 0

        counter += (@cell_map[row+1][col-1].is_alive?)? 1 : 0
        counter += (@cell_map[row+1][col].is_alive?)? 1 : 0
        counter += (@cell_map[row+1][col+1].is_alive?)? 1 : 0
      end
    elsif(row == Height-1)
      if (col == 0)
        counter += (@cell_map[row-1][col].is_alive?)? 1 : 0
        counter += (@cell_map[row-1][col+1].is_alive?)? 1 : 0
        counter += (@cell_map[row][col+1].is_alive?)? 1 : 0
      elsif(col == Width-1)
        counter += (@cell_map[row-1][col-1].is_alive?)? 1 : 0
        counter += (@cell_map[row-1][col].is_alive?)? 1 : 0
        counter += (@cell_map[row][col-1].is_alive?)? 1 : 0
      else
        counter += (@cell_map[row-1][col-1].is_alive?)? 1 : 0
        counter += (@cell_map[row-1][col].is_alive?)? 1 : 0
        counter += (@cell_map[row-1][col+1].is_alive?)? 1 : 0

        counter += (@cell_map[row][col-1].is_alive?)? 1 : 0
        #counter += (@cell_map[row][col].is_alive?)? 1 : 0
        counter += (@cell_map[row][col+1].is_alive?)? 1 : 0
      end
    elsif(col == 0)
      counter += (@cell_map[row-1][col].is_alive?)? 1 : 0
      counter += (@cell_map[row-1][col+1].is_alive?)? 1 : 0
      counter += (@cell_map[row][col+1].is_alive?)? 1 : 0
      counter += (@cell_map[row+1][col].is_alive?)? 1 : 0
      counter += (@cell_map[row+1][col+1].is_alive?)? 1 : 0
    elsif(col == Width-1)
      counter += (@cell_map[row-1][col-1].is_alive?)? 1 : 0
      counter += (@cell_map[row-1][col].is_alive?)? 1 : 0
      counter += (@cell_map[row][col-1].is_alive?)? 1 : 0
      counter += (@cell_map[row+1][col-1].is_alive?)? 1 : 0
      counter += (@cell_map[row+1][col].is_alive?)? 1 : 0
    else
      counter += (@cell_map[row-1][col-1].is_alive?)? 1 : 0
      counter += (@cell_map[row-1][col].is_alive?)? 1 : 0
      counter += (@cell_map[row-1][col+1].is_alive?)? 1 : 0

      counter += (@cell_map[row][col-1].is_alive?)? 1 : 0
      #counter += (@cell_map[row][col].is_alive?)? 1 : 0
      counter += (@cell_map[row][col+1].is_alive?)? 1 : 0

      counter += (@cell_map[row+1][col-1].is_alive?)? 1 : 0
      counter += (@cell_map[row+1][col].is_alive?)? 1 : 0
      counter += (@cell_map[row+1][col+1].is_alive?)? 1 : 0
    end
    counter
  end
end

class Cell
  Alive_graphic = 'o'
  Dead_graphic = '-'
  attr_accessor :live_state, :next_state
  def initialize(live_state = :dead)
    @live_state = live_state
    @next_state = @live_state
  end

  def cell_print
    print ( (@live_state == :alive) ? Alive_graphic : Dead_graphic)
  end

  def calc_next_state(num_of_alive_neighbour)
    if is_alive?
      if(num_of_alive_neighbour == 2 || num_of_alive_neighbour ==3 )
        @next_state = :alive
        return 'alive to alive'
      else
        @next_state = :dead
        return 'alive to dead'
      end
    else #if is dead
      if (num_of_alive_neighbour == 3)
        @next_state = :alive
        return 'dead to alive'
      else
        @next_state = :dead
        return 'dead to dead'
      end
    end
  end

  def enforce_next_state
    @live_state = @next_state
  end

  def is_alive?
    if (@live_state == :alive)
      return true
    else
      return false
    end
  end
end


b = Board.new
puts '--'
#blinker bar
  #b.setXYto(3,5,:alive)
  #b.setXYto(3,6,:alive)
  #b.setXYto(3,7,:alive)
#glider 
  b.setXYto(1,0,:alive)
  b.setXYto(2,1,:alive)
  b.setXYto(0,2,:alive)
  b.setXYto(1,2,:alive)
  b.setXYto(2,2,:alive)

b.setXYto(9,19,:alive)
b.setXYto(8,19,:alive)
b.setXYto(9,18,:alive)
puts b.get_number_of_neighbours_for_cell_at(9,19)
puts b.get_number_of_neighbours_for_cell_at(8,19)
puts b.get_number_of_neighbours_for_cell_at(9,18)
puts b.get_number_of_neighbours_for_cell_at(8,18)
puts b.get_number_of_neighbours_for_cell_at(0,4)

puts '--'
b.print_map
b.start_game
#puts "--cell test--"
  #puts Cell.new(:alive).calc_next_state(0)
  #puts Cell.new(:alive).calc_next_state(1)
  #puts Cell.new(:alive).calc_next_state(2)
  #puts Cell.new(:alive).calc_next_state(3)
  #puts Cell.new(:alive).calc_next_state(4)
  #puts Cell.new(:alive).calc_next_state(5)
  #puts '--------'
  #puts Cell.new(:dead).calc_next_state(0)
  #puts Cell.new(:dead).calc_next_state(1)
  #puts Cell.new(:dead).calc_next_state(2)
  #puts Cell.new(:dead).calc_next_state(3)
  #puts Cell.new(:dead).calc_next_state(4)






#count = 0
#puts "--cell test--"
#print Cell.new.cell_print

#puts "--Board.new.print_map test--"
#puts Board.new.print_map
#puts "--Board.new.start_game test--"
#Board.new.start_game
#while true do

  #print count
  #count+=1
  #if (count%2==0)
  #print "................\n"
  #else
  #print "****************"
  #end
  #print "\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r"
  #sleep(1);
  #system('clear')

#end

#3.times do |i|
  #print str = "string#{i}\nstring#{i}\nstring#{i}\n"
  #sleep 1 # just for test
  #system('clear')
#end

