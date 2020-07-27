require 'pry'

# hash = { type: 'tree', fruit: false, count: 3 }
hash2 = { apples: 10, oranges: 5, bananas: 1 }
array = [5, 4, 3, 2, 1, 'hello', 'world']
num_array = [9, 8, 7, 6, 2, 3, 4, 5]
stooges = %w[Larry Curly Moe]
contact_info = { 'name' => 'Bob', 'phone' => '111-111-1111' }
even_numbers = []
stock = { apples: 10, oranges: 5, bananas: 1 }
a = %w[a b c d]

def hash_iterator(arg = 0, &block)
  ind = arg
  ind.upto(length - 1) { |ind| block.call(keys[ind], values[ind]) }
  self
end

def array_iterator(&block)
  0.upto(length - 1) { |ind| block.call(self[ind]) }
  self
end

def array_iterator_with_index(&block)
  0.upto(length - 1) { |ind| block.call(self[ind], ind) }
  self
end

def class_check(arg)
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

def type_check(&block)
  if self.class == Hash
    hash_iterator(&block)
  elsif self.class == Array
    array_iterator(&block)
  end
end

def handle_numeric(arg)
  true if arg.class == Integer || arg.class == Float || arg.class == Complex
end

module Enumerable
  def my_each(&block)
    type_check(&block)
  end

  def my_each_with_index(_arg = nil, &block)
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
      case class_check(arg)
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
      case class_check(arg)
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
      case class_check(arg)
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
      case class_check(arg)
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

  def my_inject(_arg = nil, &block)
    arg = 0
    hash_iterator(&block)
  end
end
