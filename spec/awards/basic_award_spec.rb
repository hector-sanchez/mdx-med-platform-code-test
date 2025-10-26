require 'rspec'
require_relative '../../awards/basic_award'

describe BasicAward do
  describe '#update_quality!' do
    context 'before expiration' do
      it 'decreases quality by 1 and expires_in by 1' do
        award = BasicAward.new('Basic', 5, 10)
        award.update_quality!

        expect(award.expires_in).to eq(4)
        expect(award.quality).to eq(9)
      end

      it 'does not decrease quality below 0' do
        award = BasicAward.new('Basic', 5, 0)
        award.update_quality!

        expect(award.quality).to eq(0)
      end
    end

    context 'after expiration' do
      it 'decreases quality by 2 total' do
        award = BasicAward.new('Basic', 0, 10)
        award.update_quality!

        expect(award.expires_in).to eq(-1)
        expect(award.quality).to eq(8) # -1 normal, -1 additional after expiration
      end

      it 'does not decrease quality below 0 even after expiration' do
        award = BasicAward.new('Basic', 0, 1)
        award.update_quality!

        expect(award.quality).to eq(0)
      end
    end
  end
end
