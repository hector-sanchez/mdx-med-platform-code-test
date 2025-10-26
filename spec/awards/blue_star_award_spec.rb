require 'rspec'
require_relative '../../awards/blue_star_award'

describe BlueStarAward do
  describe '#update_quality!' do
    context 'before expiration' do
      it 'decreases quality by 2 and decreases expires_in by 1' do
        award = BlueStarAward.new('Blue Star', 5, 10)
        award.update_quality!

        expect(award.expires_in).to eq(4)
        expect(award.quality).to eq(8)  # loses 2 (twice as fast as normal)
      end

      it 'does not decrease quality below 0' do
        award = BlueStarAward.new('Blue Star', 5, 1)
        award.update_quality!

        expect(award.quality).to eq(0)  # would be -1, but capped at 0
      end
    end

    context 'on expiration date' do
      it 'decreases quality by 4 total (2 normal + 2 expiration penalty)' do
        award = BlueStarAward.new('Blue Star', 0, 10)
        award.update_quality!

        expect(award.expires_in).to eq(-1)
        expect(award.quality).to eq(6)  # loses 4 total: 2 + 2 expiration penalty
      end
    end

    context 'after expiration' do
      it 'decreases quality by 4 total (2 normal + 2 expiration penalty)' do
        award = BlueStarAward.new('Blue Star', -5, 10)
        award.update_quality!

        expect(award.expires_in).to eq(-6)
        expect(award.quality).to eq(6)  # loses 4 total: 2 + 2 expiration penalty
      end

      it 'does not decrease quality below 0 even after expiration' do
        award = BlueStarAward.new('Blue Star', -1, 2)
        award.update_quality!

        expect(award.quality).to eq(0)  # would be -2, but capped at 0
      end
    end

    context 'business logic validation' do
      it 'loses quality twice as fast as basic awards' do
        blue_star = BlueStarAward.new('Blue Star', 5, 20)
        # Note: We can't test BasicAward directly here, but we verify the "twice as fast" behavior
        blue_star.update_quality!

        expect(blue_star.quality).to eq(18)  # loses 2 instead of 1
      end

      it 'provides high impact when fresh but diminishes quickly' do
        fresh_award = BlueStarAward.new('Blue Star', 10, 50)

        # High impact initially
        expect(fresh_award.quality).to eq(50)

        # But diminishes quickly
        fresh_award.update_quality!
        expect(fresh_award.quality).to eq(48)  # lost 2 in one day

        fresh_award.update_quality!
        expect(fresh_award.quality).to eq(46)  # lost another 2
      end
    end
  end
end
