require_relative '../award'

# Blue Compare Award: Quality increases as expiration approaches (never above 50)
class BlueCompareAward < Award
  def update_quality!
    # Quality increases based on days left (before decrementing expires_in)
    if quality < 50
      # Base increase of 1
      self.quality += 1

      if quality < 50
        # Additional increase when 10 days or less left
        self.quality += 1 if expires_in <= 10

        # Additional increase when 5 days or less left
        self.quality += 1 if expires_in <= 5
      end
    end

    # Decrease expires_in
    self.expires_in -= 1

    # After expiration, quality drops to 0
    self.quality = 0 if expires_in < 0
  end
end
