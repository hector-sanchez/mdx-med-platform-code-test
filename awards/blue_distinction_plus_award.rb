require_relative '../award'

# Blue Distinction Plus Award: Never changes (quality stays at 80, never expires)
class BlueDistinctionPlusAward < Award
  def update_quality!
    @quality = 80
  end
end
