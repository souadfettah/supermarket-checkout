# frozen_string_literal: true

require "bigdecimal"
require "bigdecimal/util"

module Money
  module_function

  # Ensure we always work with BigDecimal
  def dec(value)
    case value
    when BigDecimal then value
    when String     then BigDecimal(value)
    when Numeric    then BigDecimal(value.to_s)
    else
      raise ArgumentError, "Unsupported money value: #{value.inspect}"
    end
  end

  # Round to 2dp using bankers' rounding (Half up suits retail totals)
  def round_2dp(value)
    dec(value).round(2, BigDecimal::ROUND_HALF_UP)
  end

  def format_gbp(value)
    "£#{format('%.2f', round_2dp(value))}"
  end
end
