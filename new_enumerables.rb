require 'pry'

# hash = { type: 'tree', fruit: false, count: 3 }
# hash2 = { apples: 10, oranges: 5, bananas: 1 }
# array = [5, 4, 3, 2, 1, 'hello', 'world']
# num_array = [9, 8, 7, 6, 2, 3, 4, 5]

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

def handle_numeric(elem)
  true if elem.class == Integer || elem.class == Float || elem.class == Complex
end

module Enumerable
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
        query
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
        my_select { |x| x == true }.length == length
      when 'Class'
        if arg == Numeric
          my_select { |x| handle_numeric(x) }.length == length
        else
          my_select { |x| x.class == arg }.length == length
        end
      end
    end
  end

  def my_any?(arg = nil, &block)
    if block_given?
      !my_select(&block).empty?
    else
      case variable_check(arg)
      when 'Regexp'
        'Regexp'
      when 'Integer'
        'Integer'
      when 'NilClass'
        !my_select { |x| x == true }.empty?
      when 'Class'
        !my_select { |x| x.class == arg }.empty?
      end
    end
  end

  def my_none?(arg = nil, &block)
    if block_given?
      my_select(&block).empty?
    else
      case variable_check(arg)
      when 'Regexp'
        my_select { |x| arg.match(x) }.empty?
      when 'Integer'
        'Integer'
      when 'NilClass'
        my_select { |x| x == true }.empty?
      when 'Class'
        my_select { |x| x.class == arg }.empty?
      end
    end
  end

  def my_count(arg = nil, &block)
    if block_given?
      my_select(&block).length
    else
      case variable_check(arg)
      when 'Integer'
        my_select { |x| x == arg }.length
      when 'NilClass'
        length
      else
        0
      end
    end
  end

  def my_map
    query = []
    array_iterator { |n| query << yield(n) }
    query
  end

  def my_inject; end
end

# stooges = %w[Larry Curly Moe]
# p stooges.my_each { |stooge, i| print stooge + "\n" + i.to_s }
#
# contact_info = { 'name' => 'Bob', 'phone' => '111-111-1111' }
# p contact_info.my_each_with_index { |key, value| print key + ' = ' + value + "\n" }
# #
# even_numbers = []
# [1, 2, 3, 4, 5, 6].my_select { |n| even_numbers << n if n.even? }
# p even_numbers
# p [1, 2, 3, 4, 5, 6].my_select { |n| n.even? }
# p [1, 2, 3, 4, 5, 6].my_select(&:even?)
# stock = { apples: 10, oranges: 5, bananas: 1 }
# p stock.my_select { |_k, v| v > 1 }
#
# p %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# p [1, 2i, 3.14].my_all?(Integer) #=> true
# p [nil, true, 99].my_all? #=> false
# p [].my_all? #=> true
# p %w[ant bear cat].my_all?(/t/) #=> false  # DOES NOT WORK YET
#
# p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# p [nil, true, 99].my_any?(Integer) #=> true
# p [nil, false].my_any? #=> true
# p [].my_any? #=> false
# p %w[ant bear cat].my_any?(/d/) #=> false  # DOES NOT WORK YET

# p %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
# p %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
# p [1, 3.14, 42].my_none?(Float) #=> false
# p [].my_none? #=> true
# p [nil].my_none? #=> true
# p [nil, false].my_none? #=> true
# p [nil, false, true].my_none? #=> false
# p %w[ant bear cat].my_none?(/t/) #=> true  # DOES NOT WORK YET
#
# p array.my_count #=> 7
# p array.my_count(2) #=> 1
# p num_array.my_count { |x| x.even? } #=> 4
# #
# a = %w[a b c d]
# p a.my_map { |x| x + '!' } #=> ["a!", "b!", "c!", "d!"]
# # p a #=> ["a", "b", "c", "d"]
# #
# p [1, 2, 3, 4].my_map { |i| i * i } #=> [1, 4, 9, 16]
# p [1, 2, 3, 4].my_map { 'cat' } #=> ["cat", "cat", "cat", "cat"]
