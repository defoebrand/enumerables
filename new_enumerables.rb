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
