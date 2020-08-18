require './enumerables'

describe Enumerable do
	let(:array) { [1, 2, 3, 2, 4] }
	let(:names) { %w[Kalu Ahmad Defoe Roy] }
	let(:hash) { {one: 1, two: 2, three: 3} }
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
			expect(hash.my_select { |x, y| y > 1 }).to eql({two: 2, three: 3})
		end

		it 'returns the elements in the range that passed the condition in the block' do
			expect(range.my_select { |x| x > 2 }).to eql([3, 4, 5, 6, 7, 8, 9, 10])
		end

		it 'returns the elements in the range that passed the condition in the block' do
			expect(range.my_select { |x| x.even? }).to eql([2, 4, 6, 8, 10])
		end

		it 'returns the elements in the range that passed the condition in the block' do
			expect(range.my_select { |x| x % 3 == 0 }).to eql([3, 6, 9])
		end

		it 'returns the elements in the range that passed the condition in the block' do
			expect(names.my_select { |x| x.length >= 5 }).to eql(["Ahmad", "Defoe"])
		end

	end

	describe "#my_all?" do
		it "returns true if no block is given" do
			expect(names.my_all?).to be true
		end

		it "returns true if all the elements in the array pass the condition in the block" do
			expect(array.my_all? {|x| x >= 1}).to be true
		end

		it "returns false if at least one element in the array does not pass the condition in the block" do
			expect(array.my_all? {|x| x >= 3}).to be false
		end

		it "returns false if at least one element in the array does not pass the condition and no block is given" do
			expect(array.my_all?(&:even?)).to be false
		end

		it "returns false if at least one value in the hash does not pass the condition in the block given" do
			expect(hash.my_all? {|x, y| y.odd?}).to be false
		end

		it "returns false if at least one element in the array does not match the regex" do
			expect(names.my_all?(/l/)).to be false
		end

		it "returns true if all the element in the array match the object type and block is not given" do
			expect(array.my_all?(Integer)).to be true
		end

		it "returns true if the array is empty and block is not given" do
			expect([].my_all?).to be true
		end

		it "returns false if at least one element in the array is a nil and no block given" do
			expect([true, 5, nil].my_all?).to be false
		end

		it "returns false if at least one element in the array does not match the argument given" do
			expect(array.my_all?(3)).to be false
		end

	end

	describe "#my_any?" do
		it "returns true if at least one element in the array matches the condition in the block" do
			expect(names.my_any? {|x| x.length > 3}).to be true
		end

		it "returns false if at least one element in the array does not match the regex" do
			expect(names.my_any?(/t/)).to be false
		end

		it "returns false if the array is empty and block is not given" do
			expect([].my_any?).to be false
		end

		it "returns true if at least one element in the array is a nil and no block given" do
			expect([true, 5, nil].my_any?).to be true
		end

		it "returns true if all the element in the array match the object type and block is not given" do
			expect([true, 5, nil].my_any?(Integer)).to be true
		end
	end

	describe "#my_none?" do
		it "returns false if at least one element in the array matches the condition in the block" do
			expect(names.my_none? {|x| x.length >= 3}).to be false
		end

		it "returns true if at least one element in the array matches the condition in the block" do
			expect(names.my_none? {|x| x.length == 8}).to be true
		end

		it "returns true if the array is empty and block is not given" do
			expect([].my_none?).to be true
		end

		it "returns false if all the element in the array match the object type and block is not given" do
			expect([1, 2, 3.14].my_none?(Float)).to be false
		end

		it "returns true if at least one element in the array does not match the regex" do
			expect(names.my_none?(/t/)).to be true
		end
	end

	describe "#my_count" do
		it 'returns the elements in the array that passed the condition' do
			expect(array.my_count).to eql(5)
		end

		it 'returns the elements in the array that passed the condition' do
			expect(hash.my_count(2)).to eql(0)
		end
		
		it 'returns the elements in the array that passed the condition' do
			expect(array.my_count(2)).to eql(2)
		end

		it "returns the elements in the array that are divisible by two without a remainder" do
			expect(array.my_count{ |x| x % 2 ==0 }).to eql(3)
		end
	end

	describe "#my_map" do
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
			expect(names.my_map { |x| x.upcase}).to eql( %w[KALU AHMAD DEFOE ROY] )
		end

		it 'returns the accumulated value in an array when a number and symbol is passed as argument and no block given' do
			expect(range.my_map { "Kalu" }).to eql(["Kalu", "Kalu", "Kalu", "Kalu", "Kalu", "Kalu", "Kalu", "Kalu", "Kalu", "Kalu"])
		end
	end

	describe "#my_inject" do
		it 'returns first element in array when no argument is given and there is one variable in the block' do
			expect(array.my_inject { |x| x }).to eql(1)
		end

		it 'returns the longest string in an array' do
			expect(names.my_inject { |x, y| x.length > y.length ? x : y }).to eql("Defoe")
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

end