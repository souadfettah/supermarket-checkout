# frozen_string_literal: true

require_relative "../money"

# If qty >= threshold, set unit price to a fraction (numerator/denominator) of original, for ALL units
# Uses exact fraction at unit level, rounding only at final total.
class FractionalPriceRule
  def initialize(code:, threshold:, numerator:, denominator:)
    @code = code
    @threshold = threshold
    @numerator = BigDecimal(numerator.to_s)
    @denominator = BigDecimal(denominator.to_s)
  end

  def discount_for(counts, catalog)
    qty = counts[@code] || 0
    return 0.to_d if qty < @threshold

    old = catalog[@code].price_dec
    new_price = old * @numerator / @denominator
    per_unit_discount = old - new_price
    -(per_unit_discount * qty)
  end
end
