require_relative '../award'

# Blue First Award: Quality increases over time (never above 50)
class BlueFirstAward < Award
  def update_quality!
    # Blue First awards increase in quality as they get older
    self.quality += 1 if quality < 50

    self.expires_in -= 1

    # After expiration, still increases in quality (never above 50)
    self.quality += 1 if expires_in < 0 && quality < 50
  end
end
