<<<<<<< HEAD
=======

>>>>>>> eea47fa5b64af3029e79f98516c7d911c5d101b9
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

  if self.class != Hash
    array_engine(&block)
  else
    hash_engine(&block)
  end
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

def t_f_test(arg, &block)
  return true unless block.call(arg).nil? || block.call(arg) == false
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
      engine_select_block_check { |n| array_query << n if t_f_test(n, &block) }
    else
      0.upto(length - 1) do |ind|
        hash_query[keys[ind]] = values[ind] unless block.call(keys[ind], values[ind]) == false
      end
    end
    array_query.empty? ? hash_query : array_query
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
