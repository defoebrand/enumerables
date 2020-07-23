hash = { type: 'tree', fruit: false, count: 3 }
array = [5, 4, 3, 2, 1, 'hello', 'world']

module Enumerable
  def my_each
    ind = 0
    length.times do
      yield(self[ind])
      ind += 1
    end
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
array.my_each_with_index { |val, ind| p "Hello, this is my value: #{val} at index: #{ind}" }
