require 'pry'

hash = { type: 'tree', fruit: false, count: 3 }
array = [5, 4, 3, 2, 1, 'hello', 'world']

module Enumerable
  def iterator
    ind = 0
    length.times { yield(self[ind]) }
    # binding.pry
  end

  def my_each
    # ind = 0
    # length.times do
    iterator { yield }
    # ind += 1
    # end
  end

  def my_each_with_index
    ind = 0
    length.times do
      yield(self[ind], ind)
      ind += 1
    end
  end
end

# array.each { |val| p "Hello, this is my value: #{val}" }
array.my_each { |val| p "Hello, this is my value: #{val}" }

# array.each_with_index { |val, ind| p "Hello, this is my value: #{val} at index: #{ind}" }
# array.my_each_with_index { |val, ind| p "Hello, this is my value: #{val} at index: #{ind}" }

# p %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
# p %w[ant bear cat].any?(/d/) #=> false
# p [nil, true, 99].any?(Integer) #=> true
# p [nil, true, 99].any? #=> true
# p [].any?
