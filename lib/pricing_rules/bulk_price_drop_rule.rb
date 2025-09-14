# frozen_string_literal: true

require_relative "../money"

# If qty >= threshold, set unit price to new_price for ALL units
class BulkPriceDropRule
  def initialize(code:, threshold:, new_price:)
    @code = code
    @threshold = threshold
    @new_price = Money.dec(new_price)
  end

  def discount_for(counts, catalog)
    qty = counts[@code] || 0
    return 0.to_d if qty < @threshold

    old = catalog[@code].price_dec
    per_unit_discount = old - @new_price
    -(per_unit_discount * qty)
  end
end
