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

  def variable_check(arg)
    if arg.class == NilClass
      'NilClass'
    elsif arg.class == Integer
      'Integer'
    elsif arg.class == Class
      'Class'
    elsif arg.class == Regexp
      'Regexp'
    end
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

  def my_all?(arg = nil, &block)
    if block_given?
      my_select(&block).length == length
    else
      case variable_check(arg)
      when 'Regexp'
        'Regexp'
      when 'Integer'
        'Integer'
      when 'NilClass'
        'NilClass'
      when 'Class'
        arg
      else
        'Variable Class not found'
      end
    end
  end

  def my_any?(arg = nil, &block)
    if block_given?
      !my_select(&block).empty?
    else
      variable_check(arg)
    end
  end

  def my_none?(arg = nil, &block)
    if block_given?
      my_select(&block).empty?
    else
      variable_check(arg)
    end
  end

  def my_count(arg = nil, &block)
    if block_given?
      my_select(&block).length
    else
      variable_check(arg)
    end
  end
end

p %w[ant bear cat].my_all?(/t/) #=> false  # DOES NOT WORK YET
p [1, 2i, 3.14].my_all?(Numeric) #=> true  # DOES NOT WORK YET
p [nil, true, 99].my_all? # DOES NOT WORK YET
p [].my_all? #=> true  # DOES NOT WORK YET

p %w[ant bear cat].my_any?(2) #=> false  # DOES NOT WORK YET
p [nil, true, 99].my_any?(Integer) #=> true  # DOES NOT WORK YET
p [nil, true, 99].my_any? #=> true  # DOES NOT WORK YET
p [].my_any? #=> false  # DOES NOT WORK YET

p %w[ant bear cat].my_none?(/d/) #=> true  # DOES NOT WORK YET
p [1, 3.14, 42].my_none?(Float) #=> false  # DOES NOT WORK YET
p [].my_none? #=> true  # DOES NOT WORK YET
p [nil].my_none? #=> true  # DOES NOT WORK YET
p [nil, false].my_none? #=> true  # DOES NOT WORK YET
p [nil, false, true].my_none? #=> false  # DOES NOT WORK YET

p array.my_count #=> 4 # DOES NOT WORK YET
p array.my_count(2) #=> 2 # DOES NOT WORK YET
