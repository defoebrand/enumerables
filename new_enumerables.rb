require 'pry'

hash = { type: 'tree', fruit: false, count: 3 }
hash2 = { apples: 10, oranges: 5, bananas: 1 }
array = [5, 4, 3, 2, 1, 'hello', 'world']

module Enumerable
  def hash_iterator(&block)
    0.upto(length - 1) { |ind| block.call(keys[ind], values[ind]) }
    self
  end

  def array_iterator(&block)
    0.upto(length - 1) { |ind| block.call(self[ind], ind) }
    self
  end

  def my_each(&block)
    if self.class == Hash
      hash_iterator(&block)
    elsif self.class == Array
      array_iterator(&block)
    end
  end

  def my_each_with_index(&block)
    my_each(&block)
  end

  def my_select(&block)
    if self.class == Array
      query = []
      array_iterator { |n| query << n if block.call(n) == true }
      query
    elsif self.class == Hash
      query = {}
      0.upto(length - 1) do |ind|
        query[keys[ind]] = values[ind] unless block.call(keys[ind], values[ind]) == false
      end
      query
    end
  end

  def my_all?(_arg = nil, &block)
    if block_given?
      my_select(&block).length == length
    else
      arg.class
    end
  end

  def my_any?(arg = nil, &block)
    if block_given?
      !my_select(&block).empty?
    else
      arg.class
    end
  end

  def my_none?(_arg = nil, &block)
    if block_given?
      my_select(&block).empty?
    else
      arg.class
    end
  end

  def my_count(arg = nil, &block)
    if block_given?
      my_select(&block).length
    else
      arg.class
    end
  end
end
<<<<<<< HEAD
even_numbers = []   
[1, 2, 3, 4, 5, 6].select { |n| even_numbers << n if n.even? }  
 p even_numbers      
  p [1, 2, 3, 4, 5, 6].select { |n| n.even? }   
  p [1, 2, 3, 4, 5, 6].select(&:even?)      
   stock = { apples: 10,  oranges: 5,  bananas: 1 }   
   p stock.my_select { |_k, v| v > 1 }
=======

p Numeric.class
# p %w[ant bear cat].my_all?(/t/) #=> false  # DOES NOT WORK YET
p [1, 2i, 3.14].my_all?(Numeric) #=> true  # DOES NOT WORK YET
# #p [nil, true, 99].my_all? # DOES NOT WORK YET
# p [].my_all? #=> true  # DOES NOT WORK YET

p %w[ant bear cat].my_any?(2) #=> false  # DOES NOT WORK YET
# p [nil, true, 99].my_any?(Integer) #=> true  # DOES NOT WORK YET
# p [nil, true, 99].my_any? #=> true  # DOES NOT WORK YET
# p [].my_any? #=> false  # DOES NOT WORK YET

# p %w[ant bear cat].my_none?(/d/) #=> true  # DOES NOT WORK YET
# p [1, 3.14, 42].my_none?(Float) #=> false  # DOES NOT WORK YET
# p [].my_none? #=> true  # DOES NOT WORK YET
# p [nil].my_none? #=> true  # DOES NOT WORK YET
# p [nil, false].my_none? #=> true  # DOES NOT WORK YET
# p [nil, false, true].my_none? #=> false  # DOES NOT WORK YET

# p array.my_count #=> 4 # DOES NOT WORK YET
# p array.my_count(2) #=> 2 # DOES NOT WORK YET
>>>>>>> 30dc5c8e27b7be40632cc4f89dcbce16f765bd44
