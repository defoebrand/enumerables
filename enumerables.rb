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

    def my_map(proc_arg = nil)
      ary = self
      ary = ary.is_a?(Array) ? ary : ary.to_a
      return enum_for unless block_given?
  
      arr = []
      i = 0
      if !proc_arg.nil?
        ary.my_each { |arr_item| arr.push(proc_arg.call(arr_item)) }
      else
        while i < ary.length
          arr.push(yield(ary[i]))
          i += 1
        end
      end
      arr
    end
  end

  def my_all?(arg = nil)
    ary = self
    ary = ary.is_a?(Array) ? ary : ary.to_a
    value = true
    return true if ary.empty?

    i = 0
    if arg.nil? && !block_given?
      while i < ary.length
        return false unless ary[i]

        i += 1
      end
    elsif arg.nil? && block_given?
      while i < ary.length
        return false unless yield(ary[i])

        i += 1
      end
    elsif !arg.nil? && !block_given?
      if arg.is_a?(Class) && !arg.is_a?(Regexp)
        while i < ary.length
          return false unless ary[i].is_a?(arg)

          i += 1
        end
      elsif arg.is_a?(Regexp)
        while i < ary.length
          str = ary[i]
          str = str.is_a?(String) ? str : str.to_s
          return false unless arg.match?(str)

          i += 1
        end
      elsif !arg.is_a?(Class)
        while i < ary.length
          return false unless arg == ary[i]

          i += 1
        end
      end
    end

    value
  end
end
#   def my_inject; end
# end



# stooges = %w[Larry Curly Moe]
# p stooges.my_each { |stooge, i| print stooge + "\n" + i.to_s }

# contact_info = { 'name' => 'Bob', 'phone' => '111-111-1111' }
# p contact_info.my_each_with_index { |key, value| print key + ' = ' + value + "\n" }

# even_numbers = []
# [1, 2, 3, 4, 5, 6].my_select { |n| even_numbers << n if n.even? }
# p even_numbers
# p [1, 2, 3, 4, 5, 6].my_select { |n| n.even? }
# p [1, 2, 3, 4, 5, 6].my_select(&:even?)
# stock = { apples: 10, oranges: 5, bananas: 1 }
# p stock.my_select { |_k, v| v > 1 }

# p %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# p [1, 2i, 3.14].my_all?(Integer) #=> true
# p [nil, true, 99].my_all? #=> false
# p [].my_all? #=> true
# p %w[ant bear cat].my_all?(/t/) #=> false  # DOES NOT WORK YET

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

# p array.my_count #=> 7
# p array.my_count(2) #=> 1
# p num_array.my_count { |x| x.even? } #=> 4













# hash = { type: 'tree', fruit: false, count: 3 }
# array = [5, 4, 3, 2, 1, 'hello', 'world']

# module Enumerable
#   def iterator
#     ind = 0
#     length.times { yield(self[ind]) }
#     # binding.pry
#   end

#   def my_each
#     # ind = 0
#     # length.times do
#     iterator { yield }
#     # ind += 1
#     # end
#   end

#   def my_each_with_index
#     ind = 0
#     length.times do
#       yield(self[ind], ind)
#       ind += 1
#     end
#   end
# end

# def my_select
#   ary = self
#   ary = ary.is_a?(Array) ? ary : ary.to_a
#   return enum_for unless block_given?

#   filtered_ary = []
#   x = 0
#   while x < ary.length
#     filtered_ary << ary[x] if yield(ary[x]) == true
#     x += 1
#   end
#   filtered_ary
# end
# # array.each { |val| p "Hello, this is my value: #{val}" }
# array.my_each { |val| p "Hello, this is my value: #{val}" }

# # array.each_with_index { |val, ind| p "Hello, this is my value: #{val} at index: #{ind}" }
# array.my_each_with_index { |val, ind| p "Hello, this is my value: #{val} at index: #{ind}" }

# # p %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
# # p %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
# # p %w[ant bear cat].any?(/d/) #=> false
# # p [nil, true, 99].any?(Integer) #=> true
# # p [nil, true, 99].any? #=> true
# # p [].any?
