# frozen_string_literal: true

require_relative "../money"

# Buy-One-Get-One-Free for a single product code
class BogoRule
  def initialize(code)
    @code = code
  end

  # Returns a negative discount to apply to subtotal
  def discount_for(counts, catalog)
    qty = counts[@code] || 0
    return 0.to_d if qty < 2

    price = catalog[@code].price_dec
    free = qty / 2
    -(price * free)
  end
end
