require 'pry'

def hash_iterator(&block)
  0.upto(length - 1) { |ind| block.call(keys[ind], values[ind]) }
  self
end

def array_iterator(&block)
  0.upto(length - 1) { |ind| block.call(self[ind], ind) }
  self
end

# def array_iterator_with_index(&block)
#   0.upto(length - 1) { |ind| block.call(self[ind], ind) }
#   self
# end

def range_iterator(arg = nil, &block)
  array = *self
  0.upto(arg.length - 1) { |ind| block.call(array[ind], ind) }
  array
end

def numeric_class(arg)
  if arg == Numeric
    my_select { |x| handle_numeric(x) }
  else
    my_select { |x| x.class == arg }
  end
end

def handle_numeric(arg)
  true if arg.class == Integer || arg.class == Float || arg.class == Complex
end

def class_check(arg)
  if arg.class == NilClass
    my_select { |x| x == true }
  elsif arg.class == Regexp
    my_select { |x| x.match?(arg) }
  elsif arg.class == String
    my_select { |x| x.include?(arg) }
  elsif arg.class == Integer
    my_select { |x| x == arg }
  elsif arg.class == Class
    numeric_class(arg)
  end
end

def type_check(&block)
  if self.class == Hash
    hash_iterator(&block)
  elsif self.class == Array
    array_iterator(&block)
  elsif self.class == Range
    array = [*self]
    range_iterator(array, &block)
  end
end

module Enumerable
  def my_each(&block)
    type_check(&block)
  end

  def my_each_with_index(_arg = nil, &block)
    my_each(&block)
  end

  def my_select(&block)
    hash_query = {}
    array_query = []
    if self.class != Hash
      type_check { |n| array_query << n if block.call(n) == true }
      array_query
    else
      0.upto(length - 1) do |ind|
        hash_query[keys[ind]] = values[ind] unless block.call(keys[ind], values[ind]) == false
        hash_query
      end
    end
  end

  def my_all?(arg = nil, &block)
    if block_given?
      my_select(&block).length == length
    else
      class_check(arg).length == length
    end
  end

  def my_any?(arg = nil, &block)
    if block_given?
      !my_select(&block).empty?
    else
      !class_check(arg).empty?
    end
  end

  def my_none?(arg = nil, &block)
    if block_given?
      my_select(&block).empty?
    else
      class_check(arg).empty?
    end
  end

  def my_count(arg = nil, &block)
    if block_given?
      my_select(&block).length
    elsif arg.class == NilClass
      length
    elsif arg.class != NilClass
      class_check(arg).length
    else
      0
    end
  end

  def my_map()
    query = []
    type_check { |n| query << yield(n) }
    query
  end

  def my_inject(arg = nil, &block)
    data = if self.class == Range
             to_a
           else
             self
           end
    arg = '' if arg.nil?
    0.upto(data.length - 1) { |ind| arg = block.call(arg, data[ind]) }
    arg
  end
end

def multiply_els(variable)
  variable.my_inject(1) { |product, n| product * n }
end
