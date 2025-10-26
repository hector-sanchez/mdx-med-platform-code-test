require_relative '../award'

# Blue Star Award: Loses quality twice as fast as normal awards
class BlueStarAward < Award
  def update_quality!
    # Decrease quality by 2 each day (twice as fast, never negative)
    if quality > 0
      self.quality -= 2
      # Ensure quality doesn't go below 0
      self.quality = 0 if quality < 0
    end

    self.expires_in -= 1

    # After expiration, quality degrades even faster (2 + 2 = 4 total per day)
    if expires_in < 0 && quality > 0
      self.quality -= 2
      # Ensure quality doesn't go below 0
      self.quality = 0 if quality < 0
    end
  end
end
