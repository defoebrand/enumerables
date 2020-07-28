def hash_engine(&block)
  0.upto(length - 1) { |index| block.call(keys[index], values[index]) }
  self
end

def array_engine(&block)
  array = convert_to_array
  0.upto(array.length - 1) { |index| block.call(array[index], index) }
  array
end

def convert_to_array
  array = if self.class == Range
            [*self]
          else
            self
          end
  array
end

def engine_select_block_check(&block)
  return to_enum unless block_given?

  hash_engine(&block) unless self.class != Hash
  array_engine(&block)
end

def class_check(arg)
  if arg.class == NilClass
    my_select { |x| x }
  elsif arg.class == Regexp
    my_select { |x| x.match?(arg) }
  elsif arg.class == String
    my_select { |x| x.include?(arg) }
  elsif arg.class == Integer
    my_select { |x| x == arg }
  elsif arg.class == Class
    numeric_inclusion(arg)
  end
end

def numeric_inclusion(arg_class)
  if arg_class == Numeric
    my_select { |arg| true if arg.class == Integer || arg.class == Float || arg.class == Complex }
  else
    my_select { |x| x.class == arg_class }
  end
end

module Enumerable
  def my_each(&block)
    engine_select_block_check(&block)
  end

  def my_each_with_index(_arg = nil, &block)
    my_each(&block)
  end

  def my_select(&block)
    return to_enum unless block_given?

    hash_query = {}
    array_query = []
    if self.class != Hash
      engine_select_block_check { |n| array_query << n if block.call(n) == true }
      array_query
    else
      0.upto(length - 1) do |ind|
        hash_query[keys[ind]] = values[ind] unless block.call(keys[ind], values[ind]) == false
        hash_query
      end
    end
    array_query.empty? ? hash_query : array_query
  end

  def my_all?(arg = nil, &block)
    if block_given?
      my_select(&block).length == length
    elsif arg.nil?
      array_query = []
      type_check { |n| array_query << n if n }
      array_query.length == length
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
      to_a.length
    elsif arg.class != NilClass
      class_check(arg).length
    else
      0
    end
  end

  def my_map(proc = nil)
    query = []
    if proc
      type_check { |n| query << proc.call(n) }
    elsif block_given?
      type_check { |n| query << yield(n) }
    else
      return to_enum
    end
    query
  end

  def my_inject(*args)
    arg = multiple_args(*args)
    array = convert_to_array
    if args[0].class == Symbol && !block_given?
      0.upto(array.length - 1) { |ind| arg = arg.send args[0], array[ind] }
    elsif args[1].class == Symbol && !block_given?
      0.upto(array.length - 1) { |ind| arg = arg.send args[1], array[ind] }
    else
      0.upto(array.length - 1) { |ind| arg = yield(arg, array[ind]) }
    end
    arg
  end
end

def multiply_els(variable)
  variable.my_inject(1) { |product, n| product * n }
end
