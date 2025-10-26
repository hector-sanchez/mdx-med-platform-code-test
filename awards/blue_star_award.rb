require_relative '../award'

# Blue Star Award: Loses quality twice as fast as normal awards
class BlueStarAward < Award
  def update_quality!
    # Decrease quality by 2 each day (twice as fast, never negative)
    readjust_quality!(multipler: -2)
    decrement_expiration!

    # After expiration, quality degrades even faster (2 + 2 = 4 total per day)
    readjust_quality!(multipler: -2) if expired?
  end
end
