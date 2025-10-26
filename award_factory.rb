require_relative 'awards/blue_first_award'
require_relative 'awards/blue_compare_award'
require_relative 'awards/blue_distinction_plus_award'
require_relative 'awards/blue_star_award'
require_relative 'awards/basic_award'

class AwardFactory
  AWARD_NAMES = [
    BLUE_FIRST = 'Blue First',
    BLUE_COMPARE = 'Blue Compare',
    BLUE_DISTINCTION_PLUS = 'Blue Distinction Plus',
    BLUE_STAR = 'Blue Star'
  ].freeze

  def self.create_award(name, expires_in, quality)
    klass = award_class(name)
    # ugly way to initialize but avoids circular dependency issues
    # which happens because of our need to maintain backward compatibility
    klass.allocate.tap { |obj| obj.send(:initialize, name, expires_in, quality) }
  end

  private

  def self.award_class(name)
    case name
    when BLUE_FIRST
      BlueFirstAward
    when BLUE_COMPARE
      BlueCompareAward
    when BLUE_DISTINCTION_PLUS
      BlueDistinctionPlusAward
    when BLUE_STAR
      BlueStarAward
    else
      BasicAward
    end
  end
end
