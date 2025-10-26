class Award
  attr_accessor :name, :expires_in, :quality

  MIN_QUANTITY = 0
  DEFAULT_MAX_QUANTITY = 50
  DEFAULT_EXPIRY_DECREMENT_STEP = 1

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
    decrement_expiration!
    readjust_quality!
  end

  protected

  def decrement_expiration!
    @expires_in -= DEFAULT_EXPIRY_DECREMENT_STEP
  end

  def readjust_quality!(multipler: -1, max_quality: DEFAULT_MAX_QUANTITY)
    @quality += multipler
    @quality = [[@quality, MIN_QUANTITY].max, max_quality].min
  end

  def expired?
    @expires_in < 0
  end
end
