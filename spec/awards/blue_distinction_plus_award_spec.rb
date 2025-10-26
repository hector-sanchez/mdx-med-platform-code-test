require 'rspec'
require_relative '../../awards/blue_distinction_plus_award'

describe BlueDistinctionPlusAward do
  describe '#update_quality!' do
    it 'never changes expires_in but always sets quality to 80' do
      award = BlueDistinctionPlusAward.new('Blue Distinction Plus', 5, 10)
      initial_expires_in = award.expires_in

      award.update_quality!

      expect(award.expires_in).to eq(initial_expires_in)
      expect(award.quality).to eq(80)  # Always 80, regardless of initial value
    end

    it 'maintains quality at 80 even when created with quality 80' do
      award = BlueDistinctionPlusAward.new('Blue Distinction Plus', 5, 80)
      initial_expires_in = award.expires_in

      award.update_quality!

      expect(award.expires_in).to eq(initial_expires_in)
      expect(award.quality).to eq(80)  # Still 80
    end

    it 'corrects quality to 80 even with negative expires_in' do
      award = BlueDistinctionPlusAward.new('Blue Distinction Plus', -1, 10)
      initial_expires_in = award.expires_in

      award.update_quality!

      expect(award.expires_in).to eq(initial_expires_in)
      expect(award.quality).to eq(80)  # Always corrected to 80
    end

    it 'demonstrates business rule: quality is always 80' do
      # Test with various initial quality values
      [0, 10, 50, 100].each do |initial_quality|
        award = BlueDistinctionPlusAward.new('Blue Distinction Plus', 5, initial_quality)
        award.update_quality!
        expect(award.quality).to eq(80), "Expected quality 80 regardless of initial value #{initial_quality}"
      end
    end
  end
end
