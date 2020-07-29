def hash_engine(&block)
  0.upto(length - 1) { |index| block.call(keys[index], values[index], index) }
  self
end

def array_engine(&block)
  0.upto(length - 1) { |index| block.call(self[index]) }
  self
end

def array_engine_with_index(&block)
  0.upto(length - 1) { |index| block.call(self[index], index) }
  self
end

def range_engine(&block)
  array = [*self]
  0.upto(array.length - 1) { |index| block.call(array[index], index) }
  array
end

def engine_select_block_check(index = nil, &block)
  return to_enum unless block_given?

  if self.class == Hash
    hash_engine(&block)
  elsif self.class == Array
    index ? array_engine_with_index(&block) : array_engine(&block)
  elsif self.class == Range
    range_engine(&block)
  end
end

def convert_to_array
  array = if self.class == Range
            [*self]
          else
            self
          end
  array
end

def class_check(arg)
  if arg.class == NilClass
    my_select { |x| x }
  elsif arg.class == Regexp
    my_select { |x| x.to_s.match?(arg) }
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

def t_f_test(arg, &block)
  var = block.call(arg)
  return true unless var.nil? || var == false
end

module Enumerable
  def my_each(&block)
    return to_enum unless block_given?

    engine_select_block_check(&block)
    self
  end

  def my_each_with_index(_arg = nil, &block)
    return to_enum unless block_given?

    index = true
    engine_select_block_check(index, &block)
    self
  end

  def my_select(&block)
    return to_enum unless block_given?

    if self.class == Hash
      query = {}
      0.upto(length - 1) do |ind|
        query[keys[ind]] = values[ind] unless block.call(keys[ind], values[ind], ind) == false
      end
    else
      query = []
      engine_select_block_check { |val| query << val if t_f_test(val, &block) }
    end
    query
  end

  def my_all?(arg = nil, &block)
    array = convert_to_array
    if arg
      class_check(arg).length == array.length
    elsif block_given?
      my_select(&block).length == array.length
    end

    if block_given?
      my_select(&block).length == array.length
    else
      class_check(arg).length == array.length
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
      engine_select_block_check { |n| query << proc.call(n) }
    elsif block_given?
      engine_select_block_check { |n| query << yield(n) }
    else
      return to_enum
    end
    query
  end

  def my_inject(*args)
    array = convert_to_array
    arg = args[0].is_a?(Numeric) ? args[0] : array[0]
    inject_symbol = args.my_select { |x| x.class == Symbol }
    offset = arg == array[0] ? 1 : 0
    if inject_symbol.empty?
      0.upto(array.length - (1 + offset)) { |ind| arg = yield(arg, array[ind + offset]) }
    else
      0.upto(array.length - (1 + offset)) { |ind| arg = arg.send(inject_symbol[0], array[ind + offset]) }
    end
    arg
  end
end

def multiply_els(variable)
  variable.my_inject(1) { |product, n| product * n }
end
