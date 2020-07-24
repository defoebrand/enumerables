require 'pry'

hash = { type: 'tree', fruit: false, count: 3 }
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
      return 'This is a hash'
      query = {}
      hash_iterator { |v| p 'yay' if block.call(v) == true; }
      # p stock.my_select { |_k, v| v > 1 } - DOES NOT WORK YET
      # self
    end
  end
end

even_numbers = []
[1, 2, 3, 4, 5, 6].select { |n| even_numbers << n if n.even? }
p even_numbers

p [1, 2, 3, 4, 5, 6].select { |n| n.even? }
p [1, 2, 3, 4, 5, 6].select(&:even?)

stock = {
  apples: 10,
  oranges: 5,
  bananas: 1
}
p stock.my_select { |_k, v| v > 1 }
