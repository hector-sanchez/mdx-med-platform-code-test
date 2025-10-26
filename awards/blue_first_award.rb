require_relative '../award'

# Blue First Award: Quality increases over time (never above 50)
class BlueFirstAward < Award
  def update_quality!
    # Blue First awards increase in quality as they get older
    readjust_quality!(multipler: 1)
    decrement_expiration!

    # After expiration, still increases in quality (never above 50)
    readjust_quality!(multipler: 1) if expired?
  end
end
