require './enumerables'

describe Enumerable do
	let(:array) { [1, 2, 3, 4] }
	let(:names) { %w[Kalu Ahmad Defoe Roy] }
	let(:hash) { {one: 1, two: 2, three: 3} }
	let(:range) { Range.new(1, 100) }
	
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

		it 'returns the element in the array that passed the condition' do
			expect(array.my_select { |x| x > 2 }).to eql([3, 4])
		end

		# it 'returns to self if self is hash and block is given' do
		# 	expect(hash.my_each { |x| x }).to eql(hash)
		# end

		# it 'returns to self if self is range and block is given' do
		# 	expect(range.my_each { |x| x }).to eql(range)
		# end

	end
	

end