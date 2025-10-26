# Pull Request: Award System Refactoring & Blue Star Implementation

## 🎯 Overview

This PR transforms the legacy award system from a monolithic `Award` class with complex conditional logic into a clean, object-oriented architecture using the Factory pattern. The refactoring implements the **Blue Star award** requirement while maintaining full backward compatibility.

## 📊 Summary of Changes

### ✅ **What Was Accomplished**
- **Ruby Version**: Upgraded from 2.7.2 → 3.4.6 (later downgraded bundler to 2.3.16 for compatibility)
- **Architecture**: Converted from single class with conditionals → Factory pattern with inheritance
- **Blue Star Implementation**: Awards lose quality twice as fast as normal awards
- **Business Logic**: Extracted award-specific behavior into dedicated classes
- **Test Coverage**: Added comprehensive specs for each award type (68 total tests, 0 failures)
- **Backward Compatibility**: Maintained existing `Award.new()` interface

### 🏗️ **Architecture Changes**

#### Before (Legacy)
```ruby
class Award
  def update_quality!
    if @name == 'Blue First'
      # Blue First logic
    elsif @name == 'Blue Compare'
      # Blue Compare logic
    elsif @name == 'Blue Distinction Plus'
      # Blue Distinction Plus logic
    else
      # Basic logic
    end
  end
end
```

#### After (Object-Oriented)
```ruby
# Base class with common behavior
class Award
  def update_quality!
    decrement_expiration!
    readjust_quality!
  end

  def self.new(name, expires_in, quality)
    AwardFactory.create_award(name, expires_in, quality)
  end
end

# Specialized classes for each award type
class BlueStarAward < Award
  def update_quality!
    readjust_quality!(multipler: -2)  # Twice as fast
    decrement_expiration!
    readjust_quality!(multipler: -2) if expired?
  end
end
```

## 🏛️ **New Architecture**

### Core Components

1. **`Award` (Base Class)**
   - Common attributes: `name`, `expires_in`, `quality`
   - Shared behavior: `decrement_expiration!`, `readjust_quality!`
   - Factory delegation for backward compatibility

2. **`AwardFactory`**
   - Constants for award names
   - Award creation logic with type detection
   - Circular dependency handling via `allocate.tap`

3. **Specialized Award Classes**
   ```
   Award/
   ├── awards/
   │   ├── basic_award.rb           # Standard degradation (-1/day)
   │   ├── blue_first_award.rb      # Increases over time (+1/day)
   │   ├── blue_compare_award.rb    # Complex expiration logic
   │   ├── blue_distinction_plus_award.rb  # Always quality 80
   │   └── blue_star_award.rb       # Degrades twice as fast (-2/day)
   ```

### Business Rules Implementation

| Award Type | Before Expiration | After Expiration | Quality Cap |
|------------|------------------|------------------|-------------|
| **Basic** | -1 per day | -2 per day | 50 |
| **Blue First** | +1 per day | +1 per day | 50 |
| **Blue Compare** | +1/+2/+3 per day* | 0 (drops to zero) | 50 |
| **Blue Distinction Plus** | Always 80 | Always 80 | 80 |
| **Blue Star** | -2 per day | -4 per day | 50 |

*Blue Compare increases by +1 normally, +2 with ≤10 days, +3 with ≤5 days

## 🤝 **Compromises & Unorthodox Decisions**

### 1. **Factory Method Override**
```ruby
class Award
  def self.new(name, expires_in, quality)
    require_relative 'award_factory'
    AwardFactory.create_award(name, expires_in, quality)
  end
end
```
**Why**: Maintaining backward compatibility while enabling polymorphism
**Trade-off**: Unusual pattern but preserves existing `Award.new()` calls

### 2. **Circular Dependency Workaround**
```ruby
def self.create_award(name, expires_in, quality)
  klass = award_class(name)
  # Bypass circular dependency with allocate.tap
  klass.allocate.tap { |obj| obj.send(:initialize, name, expires_in, quality) }
end
```
**Why**: Award classes inherit from `Award`, but `Award.new` delegates to factory
**Trade-off**: Unorthodox instantiation pattern, but avoids circular requires

### 3. **Blue Distinction Plus Quality Override**
```ruby
def update_quality!
  @quality = 80  # Always reset to 80
end
```
**Why**: Business rule requires quality to always be 80, regardless of initial value
**Trade-off**: Direct instance variable manipulation, but clearest implementation

### 4. **Protected Helper Methods in Base Class**
```ruby
protected

def readjust_quality!(multipler: -1, max_quality: DEFAULT_MAX_QUANTITY)
  @quality += multipler
  @quality = [[@quality, MIN_QUANTITY].max, max_quality].min
end
```
**Why**: Centralize quality bounds logic while allowing customization
**Trade-off**: Base class knows about all quality adjustment patterns

## 🚀 **Future Improvements**

*If backward compatibility wasn't required:*

### 1. **Clean Factory Pattern**
```ruby
# Remove factory method override from Award
class AwardFactory
  def self.create(type:, expires_in:, quality:)
    case type
    when :blue_star then BlueStarAward.new(expires_in, quality)
    when :blue_first then BlueFirstAward.new(expires_in, quality)
    # ...
    end
  end
end

# Usage
award = AwardFactory.create(type: :blue_star, expires_in: 10, quality: 20)
```

### 2. **Strategy Pattern for Quality Updates**
```ruby
class Award
  def initialize(expires_in, quality, strategy: BasicQualityStrategy.new)
    @expires_in = expires_in
    @quality = quality
    @strategy = strategy
  end

  def update_quality!
    @strategy.update_quality(self)
  end
end

class BlueStarQualityStrategy
  def update_quality(award)
    award.quality -= 2
    award.expires_in -= 1
    award.quality -= 2 if award.expired?
  end
end
```

### 3. **Value Objects with Immutability**
```ruby
class Award
  attr_reader :name, :expires_in, :quality

  def initialize(name, expires_in, quality)
    @name = name.freeze
    @expires_in = expires_in
    @quality = quality
    freeze
  end

  def update_quality
    # Return new instance instead of mutation
    self.class.new(@name, new_expires_in, new_quality)
  end
end
```

### 4. **Configuration-Driven Rules**
```ruby
class AwardRulesConfig
  RULES = {
    'Blue Star' => {
      quality_multiplier: -2,
      expiration_multiplier: -2,
      max_quality: 50
    },
    'Blue First' => {
      quality_multiplier: 1,
      expiration_multiplier: 1,
      max_quality: 50
    }
  }.freeze
end
```

### 5. **Event-Driven Updates**
```ruby
class AwardService
  def process_daily_updates
    awards.each do |award|
      old_state = award.state
      award.update_quality!
      publish_event(:award_updated, old_state, award.state)
    end
  end
end
```

## 🧪 **Testing & Validation**

- **68 total tests** passing (0 failures)
- **35 legacy tests** maintained and passing
- **33 new comprehensive tests** for refactored architecture
- **Individual test files** for each award type
- **Business rule validation** with demo scripts

## 📋 **Migration Impact**

### ✅ **No Breaking Changes**
- All existing `Award.new(name, expires_in, quality)` calls work unchanged
- Public interface (`name`, `expires_in`, `quality`, `update_quality!`) preserved
- Test suite maintains 100% compatibility

### 🔄 **Performance Considerations**
- **Factory overhead**: Minimal (one-time class lookup per instantiation)
- **Memory**: Slight increase due to additional class files
- **Runtime**: Equivalent or better (polymorphism vs conditionals)

## 🎉 **Blue Star Implementation**

The new **Blue Star** award successfully implements the requirement:

```ruby
# Before expiration: loses 2 quality per day (twice as fast)
# After expiration: loses 4 quality per day (2 + 2 expiration penalty)
# Quality never goes below 0

blue_star = Award.new('Blue Star', 5, 20)
blue_star.update_quality!  # quality: 18 (lost 2)
# After 5 days and expiration...
blue_star.update_quality!  # quality: 10 (lost 4: 2 normal + 2 expiration)
```

This provides the desired behavior where Blue Star awards have high initial impact but diminish quickly over time, helping distinguish high-quality providers when the award is fresh.
