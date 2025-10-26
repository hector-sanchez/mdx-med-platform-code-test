require 'rspec'
require_relative '../award_factory'

describe AwardFactory do
  describe '.create_award' do
    it 'creates BlueFirstAward for "Blue First"' do
      award = AwardFactory.create_award('Blue First', 5, 10)
      expect(award).to be_a(BlueFirstAward)
      expect(award.name).to eq('Blue First')
    end

    it 'creates BlueCompareAward for "Blue Compare"' do
      award = AwardFactory.create_award('Blue Compare', 5, 10)
      expect(award).to be_a(BlueCompareAward)
      expect(award.name).to eq('Blue Compare')
    end

    it 'creates BlueDistinctionPlusAward for "Blue Distinction Plus"' do
      award = AwardFactory.create_award('Blue Distinction Plus', 5, 10)
      expect(award).to be_a(BlueDistinctionPlusAward)
      expect(award.name).to eq('Blue Distinction Plus')
    end

    it 'creates BlueStarAward for "Blue Star"' do
      award = AwardFactory.create_award('Blue Star', 5, 10)
      expect(award).to be_a(BlueStarAward)
      expect(award.name).to eq('Blue Star')
    end

    it 'creates BasicAward for unknown award names' do
      award = AwardFactory.create_award('Unknown Award', 5, 10)
      expect(award).to be_a(BasicAward)
      expect(award.name).to eq('Unknown Award')
    end

    it 'creates BasicAward for empty string' do
      award = AwardFactory.create_award('', 5, 10)
      expect(award).to be_a(BasicAward)
      expect(award.name).to eq('')
    end

    it 'creates BasicAward for nil name' do
      award = AwardFactory.create_award(nil, 5, 10)
      expect(award).to be_a(BasicAward)
      expect(award.name).to be_nil
    end
  end

  describe 'AWARD_NAMES constants' do
    it 'has the correct award name constants' do
      expect(AwardFactory::BLUE_FIRST).to eq('Blue First')
      expect(AwardFactory::BLUE_COMPARE).to eq('Blue Compare')
      expect(AwardFactory::BLUE_DISTINCTION_PLUS).to eq('Blue Distinction Plus')
      expect(AwardFactory::BLUE_STAR).to eq('Blue Star')
    end

    it 'has a frozen AWARD_NAMES array' do
      expect(AwardFactory::AWARD_NAMES).to be_frozen
      expect(AwardFactory::AWARD_NAMES).to include('Blue First', 'Blue Compare', 'Blue Distinction Plus', 'Blue Star')
    end
  end
end
