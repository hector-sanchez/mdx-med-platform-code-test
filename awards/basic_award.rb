require_relative '../award'

class BasicAward < Award
  def update_quality!
    decrement_expiration!
    readjust_quality!

    # After expiration, quality degrades twice as fast (never negative)
    readjust_quality! if expired?
  end
end
