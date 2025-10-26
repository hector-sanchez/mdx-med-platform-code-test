require 'rspec'
require_relative '../../awards/blue_compare_award'

describe BlueCompareAward do
  describe '#update_quality!' do
    context 'more than 10 days before expiration' do
      it 'increases quality by 1' do
        award = BlueCompareAward.new('Blue Compare', 15, 10)
        award.update_quality!

        expect(award.expires_in).to eq(14)
        expect(award.quality).to eq(11)
      end
    end

    context '10 days or less before expiration' do
      it 'increases quality by 2' do
        award = BlueCompareAward.new('Blue Compare', 10, 10)
        award.update_quality!

        expect(award.expires_in).to eq(9)
        expect(award.quality).to eq(12)
      end
    end

    context '5 days or less before expiration' do
      it 'increases quality by 3' do
        award = BlueCompareAward.new('Blue Compare', 5, 10)
        award.update_quality!

        expect(award.expires_in).to eq(4)
        expect(award.quality).to eq(13)
      end
    end

    context 'after expiration' do
      it 'drops quality to 0' do
        award = BlueCompareAward.new('Blue Compare', 0, 10)
        award.update_quality!

        expect(award.expires_in).to eq(-1)
        expect(award.quality).to eq(0)
      end
    end

    context 'quality limits' do
      it 'does not increase quality above 50' do
        award = BlueCompareAward.new('Blue Compare', 5, 49)
        award.update_quality!

        expect(award.quality).to eq(50)
      end
    end
  end
end
