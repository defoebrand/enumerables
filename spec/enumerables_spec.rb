require_relative '../enumerables'

describe Enumerable do
  let(:array) { [1, 2, 3, 2, 4] }
  let(:names) { %w[Kalu Ahmad Defoe Roy] }
  let(:hash) { { one: 1, two: 2, three: 3 } }
  let(:range) { Range.new(1, 10) }

  describe '#my_each' do
    it 'returns to an Enumerator if block is not given' do
      expect(array.my_each).to be_an(Enumerator)
    end

    it 'returns to self if self is array and block is given' do
      expect(names.my_each { |x| x }).to eql(names)
    end

    it 'returns to self if self is hash and block is given' do
      expect(hash.my_each { |x| x }).to eql(hash)
    end

    it 'returns to self if self is range and block is given' do
      expect(range.my_each { |x| x }).to eql(range)
    end
  end

  describe '#my_each_with_index' do
    it 'returns to an Enumerator if block is not given' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end

    it 'returns to self if self is array and block is given' do
      expect(names.my_each_with_index { |x| x }).to eql(names)
    end

    it 'returns to self if self is hash and block is given' do
      expect(hash.my_each_with_index { |x| x }).to eql(hash)
    end

    it 'returns to self if self is range and block is given' do
      expect(range.my_each_with_index { |x| x }).to eql(range)
    end
  end

  describe '#my_select' do
    it 'returns to an Enumerator if block is not given' do
      expect(array.my_select).to be_an(Enumerator)
    end

    it 'returns the elements in the array that passed the condition in the block' do
      expect(array.my_select { |x| x > 2 }).to eql([3, 4])
    end

    it 'returns to the elements in the hash that passed the condition in the block' do
      expect(hash.my_select { |_x, y| y > 1 }).to eql({ two: 2, three: 3 })
    end

    it 'returns the elements in the range that passed the condition in the block' do
      expect(range.my_select { |x| x > 2 }).to eql([3, 4, 5, 6, 7, 8, 9, 10])
    end

    it 'returns the elements in the range that passed the condition in the block' do
      expect(range.my_select(&:even?)).to eql([2, 4, 6, 8, 10])
    end

    it 'returns the elements in the range that passed the condition in the block' do
      expect(range.my_select { |x| x % 3 == 0 }).to eql([3, 6, 9])
    end

    it 'returns the elements in the range that passed the condition in the block' do
      expect(names.my_select { |x| x.length >= 5 }).to eql(%w[Ahmad Defoe])
    end
  end

  describe '#my_all?' do
    it 'returns true if no block is given' do
      expect(names.my_all?).to be true
    end

    it 'returns true if all the elements in the array pass the condition in the block' do
      expect(array.my_all? { |x| x >= 1 }).to be true
    end

    it 'returns false if at least one element in the array does not pass the condition in the block' do
      expect(array.my_all? { |x| x >= 3 }).to be false
    end

    it 'returns false if at least one element in the array does not pass the condition and no block is given' do
      expect(array.my_all?(&:even?)).to be false
    end

    it 'returns false if at least one value in the hash does not pass the condition in the block given' do
      expect(hash.my_all? { |_x, y| y.odd? }).to be false
    end

    it 'returns false if at least one element in the array does not match the regex' do
      expect(names.my_all?(/l/)).to be false
    end

    it 'returns true if all the element in the array match the object type and block is not given' do
      expect(array.my_all?(Integer)).to be true
    end

    it 'returns true if the array is empty and block is not given' do
      expect([].my_all?).to be true
    end

    it 'returns false if at least one element in the array is a nil and no block given' do
      expect([true, 5, nil].my_all?).to be false
    end

    it 'returns false if at least one element in the array does not match the argument given' do
      expect(array.my_all?(3)).to be false
    end
  end

  describe '#my_any?' do
    it 'returns true if at least one element in the array matches the condition in the block' do
      expect(names.my_any? { |x| x.length > 3 }).to be true
    end

    it 'returns false if at least one element in the array does not match the regex' do
      expect(names.my_any?(/t/)).to be false
    end

    it 'returns false if the array is empty and block is not given' do
      expect([].my_any?).to be false
    end

    it 'returns true if at least one element in the array is a nil and no block given' do
      expect([true, 5, nil].my_any?).to be true
    end

    it 'returns true if all the element in the array match the object type and block is not given' do
      expect([true, 5, nil].my_any?(Integer)).to be true
    end
  end

  describe '#my_none?' do
    it 'returns false if at least one element in the array matches the condition in the block' do
      expect(names.my_none? { |x| x.length >= 3 }).to be false
    end

    it 'returns true if at least one element in the array matches the condition in the block' do
      expect(names.my_none? { |x| x.length == 8 }).to be true
    end

    it 'returns true if the array is empty and block is not given' do
      expect([].my_none?).to be true
    end

    it 'returns false if all the element in the array match the object type and block is not given' do
      expect([1, 2, 3.14].my_none?(Float)).to be false
    end

    it 'returns true if at least one element in the array does not match the regex' do
      expect(names.my_none?(/t/)).to be true
    end
  end

  describe '#my_count' do
    it 'returns the elements in the array that passed the condition' do
      expect(array.my_count).to eql(5)
    end

    it 'returns the elements in the array that passed the condition' do
      expect(hash.my_count(2)).to eql(0)
    end

    it 'returns the elements in the array that passed the condition' do
      expect(array.my_count(2)).to eql(2)
    end

    it 'returns the elements in the array that are divisible by two without a remainder' do
      expect(array.my_count(&:even?)).to eql(3)
    end
  end

  describe '#my_map' do
    it 'returns to an Enumerator if block is not given' do
      expect(array.my_map).to be_an(Enumerator)
    end

    it 'returns the elements in the array that passed the condition in the block' do
      expect(array.my_map { |x| x * x }).to eql([1, 4, 9, 4, 16])
    end

    it 'returns the elements in the array that passed the condition in the block' do
      expect(range.my_map { |x| x * x }).to eql([1, 4, 9, 16, 25, 36, 49, 64, 81, 100])
    end

    it 'returns the elements in the array that passed the condition in the block' do
      expect(names.my_map(&:upcase)).to eql(%w[KALU AHMAD DEFOE ROY])
    end

    it 'returns the string the number of times  in the range and block given' do
      expect(range.my_map { 'Kalu' }).to eql(%w[Kalu Kalu Kalu Kalu Kalu Kalu Kalu Kalu Kalu Kalu])
    end
  end

  describe '#my_inject' do
    it 'returns first element in array when no argument is given and there is one variable in the block' do
      expect(array.my_inject { |x| x }).to eql(1)
    end

    it 'returns the longest string in an array' do
      expect(names.my_inject { |x, y| x.length > y.length ? x : y }).to eql('Defoe')
    end

    it 'returns first element in a range when no argument is given and there is one variable in the block' do
      expect(range.my_inject { |x| x }).to eql(1)
    end

    it 'returns first element in a range when no argument is given and there is one variable in the block' do
      expect(range.my_inject { |x| x }).to eql(1)
    end

    it 'returns the sum of the numbers in the array when a block is given' do
      expect(range.my_inject { |x, y| x + y }).to eql(55)
    end

    it 'returns the sum of numbers in an array when a symbol is passed as an argument and no block given' do
      expect(array.my_inject(:+)).to eql(12)
    end

    it 'returns the accumulated value in an array when a number and symbol is passed as argument and no block given' do
      expect(array.my_inject(2, :*)).to eql(96)
    end
  end

  describe '#multiply_els' do
    it 'returns the result of the numbers multiplied in the argument given' do
      expect(multiply_els([2, 3, 4])).to eql(24)
    end
  end

  # Helper methods tests
  # Helper methods tests

  describe '#engine_select_block_check' do
    it 'returns to Enumerator if block is not given' do
      expect(range.engine_select_block_check).to be_an(Enumerator)
    end

    it 'returns self if block is given' do
      expect(array.engine_select_block_check { |index| index }).to eql(array)
    end

    it 'returns self if block is given' do
      expect(hash.engine_select_block_check { |index| index }).to eql(hash)
    end

    it 'returns an array if block is given' do
      expect(range.engine_select_block_check { |index| index }).to eql([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    end
  end

  describe '#convert_to_array' do
    it 'returns an array if a range is passsed without block given' do
      expect(range.convert_to_array).to eql([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    end

    it 'returns self if a range is not passsed without block given' do
      expect(hash.convert_to_array).to eql(hash)
    end
  end

  describe '#array_engine' do
    it 'returns self' do
      expect([1, 2, 3, 2, 4].array_engine { |index| index }).to eql([1, 2, 3, 2, 4])
    end
  end

  describe '#hash_engine' do
    it 'returns self' do
      expect({ one: 1, two: 2 }.hash_engine { |index| index }).to eql({ one: 1, two: 2 })
    end
  end

  describe '#array_engine_with_index' do
    it 'returns self' do
      expect([1, 2, 3, 2, 4].array_engine_with_index { |index| index }).to eql([1, 2, 3, 2, 4])
    end
  end

  describe '#range_engine' do
    it 'returns self' do
      expect((0..10).range_engine { |index| index }).to eql([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    end
  end

  describe '#class_check' do
    it 'returns the element that matches the argument passed if block is given' do
      expect(array.class_check(1) { |x| x }).to eql([1])
    end

    it 'returns the element that matches the argument passed if block is given' do
      expect(array.class_check(/t/) { |x| x }).to eql([])
    end

    it 'returns the element that matches the argument passed if block is given' do
      expect(names.class_check('Kalu') { |x| x }).to eql(['Kalu'])
    end

    it 'returns the element in the array that matches the class passed in the argument and no block given' do
      expect(names.class_check(String)).to eql(%w[Kalu Ahmad Defoe Roy])
    end

    it 'returns the element that matches the argument passed if block is given' do
      expect(array.class_check(nil) { |x| x }).to eql([1, 2, 3, 2, 4])
    end
  end

  describe '#numeric_inclusion' do
    it 'returns self if the argument passed in a given block is an Integer or Float or Complex number' do
      expect(array.numeric_inclusion(Integer)).to eql([1, 2, 3, 2, 4])
    end

    it 'returns empty if the argument passed in a given block is not an Integer or Float or Complex number' do
      expect(array.numeric_inclusion(String)).to eql([])
    end
  end

  describe '#t_f_test' do
    it 'returns true if the argument passed is neither nil or false and block is given' do
      expect(array.t_f_test('kalu') { |x| x }).to be true
    end

    it 'returns true if the argument passed is neither nil or false and block is given' do
      expect(array.t_f_test(false) { |x| x }).to be nil
    end
  end
end
