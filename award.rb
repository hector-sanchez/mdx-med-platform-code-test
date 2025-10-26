class Award
  attr_accessor :name, :expires_in, :quality

  MIN_QUANTITY = 0

  def initialize(name, expires_in, quality)
    @name = name
    @expires_in = expires_in
    @quality = quality
  end

  def self.new(name, expires_in, quality)
    require_relative 'award_factory'
    AwardFactory.create_award(name, expires_in, quality)
  end

  def update_quality!
    recalculate_quality_and_expiration
  end

  protected

  def recalculate_quality_and_expiration(quality_multipler: -1, max_quality: 50, expiration_decrement: 1)
    @expires_in -= expiration_decrement
    recalculate_quality(multipler: quality_multipler, max_quality: max_quality)
  end

  def recalculate_quality(multipler: -1, max_quality: 50)
    @quality += multipler
    @quality = [[@quality, MIN_QUANTITY].max, max_quality].min
  end

  def expired?
    @expires_in < 0
  end
end
