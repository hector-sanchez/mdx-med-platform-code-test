require_relative '../award'

# Blue Compare Award: Quality increases as expiration approaches (never above 50)
class BlueCompareAward < Award
  def update_quality!
    # Quality increases based on days left (before decrementing expires_in)
    readjust_quality!(multipler: 1)

    # Additional increase when 10 days or less left
    readjust_quality!(multipler: 1) if expires_in <= 10

    # Additional increase when 5 days or less left
    readjust_quality!(multipler: 1) if expires_in <= 5

    # Decrease expires_in
    decrement_expiration!

    # After expiration, quality drops to 0
    self.quality = 0 if expired?
  end
end
