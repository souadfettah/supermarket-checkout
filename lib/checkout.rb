# frozen_string_literal: true

require_relative "money"

class Checkout
  def initialize(pricing_rules:, catalog:)
    @pricing_rules = pricing_rules
    @catalog = catalog
    @items = []
  end

  def scan(item_code)
    # Validate item exists; errors early if not
    @catalog[item_code]
    @items << item_code
    self
  end

  def total
    counts = @items.tally
    subtotal = counts.sum { |code, qty| @catalog[code].price_dec * qty }

    total_discount = @pricing_rules.sum { |rule| rule.discount_for(counts, @catalog) }

    Money.round_2dp(subtotal + total_discount)
  end

  def total_formatted
    Money.format_gbp(total)
  end
end
