require_relative '../award'

class BasicAward < Award
  def update_quality!
    self.quality -= 1 if quality > 0
    self.expires_in -= 1

    # After expiration, quality degrades twice as fast (never negative)
    self.quality -= 1 if expires_in < 0 && quality > 0
  end
end
