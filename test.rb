require './enumerables'

hash = {}
array = [5, 4, 3, 2, 1, 'hello', 'world']
num_array = [9, 8, 7, 6, 2, 3, 4, 5]
stooges = %w[Larry Curly Moe]
contact_info = { 'name' => 'Bob', 'phone' => '111-111-1111' }
even_numbers = []
stock = { apples: 10, oranges: 5, bananas: 1 }
a = %w[a b c d]
longest = %w[cat sheep bear]

puts 'Default Tests'
puts ''

p(stooges.each { |stooge| print stooge + "\n" })
p stooges.each
p(contact_info.each { |key, value| print key + ' = ' + value + "\n" })

(1..5).each_with_index { |num, ind| p "#{num}: #{ind}" }
p(1..5).each_with_index
%w[cat dog wombat].each_with_index do |item, index|
  hash[item] = index
end
p hash #=> {"cat"=>0, "dog"=>1, "wombat"=>2}

[1, 2, 3, 4, 5, 6].select { |n| even_numbers << n if n.even? }
p even_numbers
p((1..6).select(&:even?))
p [1, 2, 3, 4, 5, 6].select(&:even?)
p(stock.select { |_k, v| v > 1 })
p stock
p(contact_info.select { |_k, v| v == 'Bob' })
p contact_info

p(%w[ant bear cat].all? { |word| word.length >= 3 }) #=> true
p(%w[ant bear cat].all? { |word| word.length >= 4 }) #=> false
p [1, 2i, 3.14].all?(Integer) #=> true
p [nil, true, 99].all? #=> false
p [].all? #=> true
p %w[ant bear cat].all?(/t/) #=> false
p [2, 1, 6, 7, 4, 8, 10].all?(3) # => false
p %w[Marc Luc Jean].all?('Jean') # => false
p %w[Marc Luc Jean].all?(/a/) # => false
#
p(%w[ant bear cat].any? { |word| word.length >= 3 }) #=> true
p(%w[ant bear cat].any? { |word| word.length >= 4 }) #=> true
p(%w[ant bear cat].all? { |word| word == 'cow' }) #=> false
p [nil, true, 99].any?(Integer) #=> true
p [nil, false].any? #=> true
p [].any? #=> false
p %w[ant bear cat].any?(/d/) #=> false
p %w[Marc Luc Jean].any?(/d/) # => false
p [2, 1, 6, 7, 4, 8, 10].any?(7) # => true
p %w[Marc Luc Jean].any?('Jean') # => true
p [nil, true, 99].any?(Integer) # => true
p ['1', 5i, 5.67].any?(Numeric) # => true

p(%w[ant bear cat].none? { |word| word.length == 5 }) #=> true
p(%w[ant bear cat].none? { |word| word.length >= 4 }) #=> false
p [1, 3.14, 42].none?(Float) #=> false
p [].none? #=> true
p [nil].none? #=> true
p [nil, false].none? #=> true
p [nil, false, true].none? #=> false
p %w[ant bear cat].none?(/t/) #=> false
p %w[Marc Luc Jean].none?(/j/) #=> true
p [2, 1, 6, 7, 4, 8, 10].none?(15) #=> true
p %w[Marc Luc Jean].none?('Jean') # => false
p [1, 3.14, 42].none?(Float) # => false
p [1, 5i, 5.67].none?(Numeric) # => false

p array.count #=> 7
p array.count(2) #=> 1
p(num_array.count(&:even?)) #=> 4
p(1..4).count

p((1..4).map { |i| i * i })
p([1, 2, 3, 4].map { |i| i * i }) #=> [1, 4, 9, 16]
p([1, 2, 3, 4].map { 'cat' }) #=> ["cat", "cat", "cat", "cat"]
p(a.map { |x| x + '!' }) #=> ["a!", "b!", "c!", "d!"]
p a #=> ["a", "b", "c", "d"]
# #
p(5..10).inject(:+)
p [1, 2, 3, 5, 8].inject(:+)
p(5..10).inject(1, :*)
p(5..10).inject(1) { |product, n| product * n }
p(5..8).inject(0) { |result_memo, object| result_memo + object } # =>
p [5, 6, 7, 8].inject(0) { |result_memo, object| result_memo + object } # => 26
p(longest.inject { |memo, word| memo.length > word.length ? memo : word })
p longest

# # = = = = = = = =  MY ENUMERABLES TESTS = = = = = = = = # #
puts ''
puts 'My Enumerables Tests'
puts ''

hash = {}
array = [5, 4, 3, 2, 1, 'hello', 'world']
num_array = [9, 8, 7, 6, 2, 3, 4, 5]
stooges = %w[Larry Curly Moe]
contact_info = { 'name' => 'Bob', 'phone' => '111-111-1111' }
even_numbers = []
stock = { apples: 10, oranges: 5, bananas: 1 }
a = %w[a b c d]
longest = %w[cat sheep bear]

p(stooges.my_each { |stooge| print stooge + "\n" })
p stooges.my_each
p(contact_info.my_each { |key, value| print key + ' = ' + value + "\n" })

(1..5).my_each_with_index { |num, ind| p "#{num}: #{ind}" }
p (1..5).my_each_with_index
%w[cat dog wombat].my_each_with_index do |item, index|
  hash[item] = index
end
p hash #=> {"cat"=>0, "dog"=>1, "wombat"=>2}

[1, 2, 3, 4, 5, 6].my_select { |n| even_numbers << n if n.even? }
p even_numbers
p((1..6).my_select(&:even?))
p [1, 2, 3, 4, 5, 6].my_select(&:even?)
p [1, 2, 3, 4, 5, 6].my_select
p(stock.my_select { |_k, v| v > 1 })
p stock
p(contact_info.my_select { |_k, v| v == 'Bob' })
p contact_info

p(%w[ant bear cat].my_all? { |word| word.length >= 3 }) #=> true
p(%w[ant bear cat].my_all? { |word| word.length >= 4 }) #=> false
p(%w[ant bear cat].my_all? { |word| word == 'cow' }) #=> false
p [1, 2i, 3.14].my_all?(Integer) #=> true
p [nil, true, 99].my_all? #=> false
p [].my_all? #=> true
p %w[ant bear cat].my_all?(/t/) #=> false
p [2, 1, 6, 7, 4, 8, 10].my_all?(3) # => false
p %w[Marc Luc Jean].my_all?('Jean') # => false
p %w[Marc Luc Jean].my_all?(/a/) # => false
#
p(%w[ant bear cat].my_any? { |word| word.length >= 3 }) #=> true
p(%w[ant bear cat].my_any? { |word| word.length >= 4 }) #=> true
p [nil, true, 99].my_any?(Integer) #=> true
p [nil, false].my_any? #=> true
p [].my_any? #=> false
p %w[ant bear cat].my_any?(/d/) #=> false
p %w[Marc Luc Jean].my_any?(/d/) # => false
p [2, 1, 6, 7, 4, 8, 10].my_any?(7) # => true
p %w[Marc Luc Jean].my_any?('Jean') # => true
p [nil, true, 99].my_any?(Integer) # => true
p ['1', 5i, 5.67].my_any?(Numeric) # => true

p(%w[ant bear cat].my_none? { |word| word.length == 5 }) #=> true
p(%w[ant bear cat].my_none? { |word| word.length >= 4 }) #=> false
p [1, 3.14, 42].my_none?(Float) #=> false
p [].my_none? #=> true
p [nil].my_none? #=> true
p [nil, false].my_none? #=> true
p [nil, false, true].my_none? #=> false
p %w[ant bear cat].my_none?(/t/) #=> true
p %w[Marc Luc Jean].my_none?(/j/) #=> true
p [2, 1, 6, 7, 4, 8, 10].my_none?(15) #=> true
p %w[Marc Luc Jean].my_none?('Jean') # => false
p [1, 3.14, 42].my_none?(Float) # => false
p [1, 5i, 5.67].my_none?(Numeric) # => false

p array.my_count #=> 7
p array.my_count(2) #=> 1
p(num_array.my_count(&:even?)) #=> 4
p(1..4).my_count
p((1..4).my_map { |i| i * i })
p([1, 2, 3, 4].my_map { |i| i * i }) #=> [1, 4, 9, 16]
p([1, 2, 3, 4].my_map { 'cat' }) #=> ["cat", "cat", "cat", "cat"]
p(a.my_map { |x| x + '!' }) #=> ["a!", "b!", "c!", "d!"]
p a #=> ["a", "b", "c", "d"]

p(5..10).my_inject(:+)
p [1, 2, 3, 5, 8].my_inject(:+)
p(5..10).my_inject(1, :*)
p(5..10).my_inject(1) { |product, n| product * n }
p(5..8).my_inject(0) { |result_memo, object| result_memo + object } # =>
p [5, 6, 7, 8].my_inject(0) { |result_memo, object| result_memo + object } # => 26
p(5..10).my_inject { |sum, n| sum + n }
p(longest.my_inject { |memo, word| memo.length > word.length ? memo : word })
p longest
p multiply_els([2, 4, 5])
p [2, 3, 5, 6, 1, 7, 5, 3, 9].my_inject { |sum, n| sum * n }
check = [2, 1, 3, 4, 5]
p check.my_inject { |sum, n| sum * n }
p check
