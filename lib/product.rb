# frozen_string_literal: true

require_relative "money"

Product = Struct.new(:code, :name, :price, keyword_init: true) do
  def price_dec
    Money.dec(price)
  end
end
