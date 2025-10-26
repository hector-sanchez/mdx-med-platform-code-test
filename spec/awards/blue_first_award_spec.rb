require 'rspec'
require_relative '../../awards/blue_first_award'

describe BlueFirstAward do
  describe '#update_quality!' do
    context 'before expiration' do
      it 'increases quality by 1 and decreases expires_in by 1' do
        award = BlueFirstAward.new('Blue First', 5, 10)
        award.update_quality!

        expect(award.expires_in).to eq(4)
        expect(award.quality).to eq(11)
      end

      it 'does not increase quality above 50' do
        award = BlueFirstAward.new('Blue First', 5, 50)
        award.update_quality!

        expect(award.quality).to eq(50)
      end
    end

    context 'after expiration' do
      it 'still increases quality by 1' do
        award = BlueFirstAward.new('Blue First', 0, 10)
        award.update_quality!

        expect(award.expires_in).to eq(-1)
        expect(award.quality).to eq(12) # +1 normal, +1 after expiration
      end

      it 'does not increase quality above 50 even after expiration' do
        award = BlueFirstAward.new('Blue First', 0, 50)
        award.update_quality!

        expect(award.quality).to eq(50)
      end
    end
  end
end
