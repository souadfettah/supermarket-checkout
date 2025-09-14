# frozen_string_literal: true

require_relative "product"

class Catalog
  def initialize(products)
    @by_code = {}
    products.each { |p| @by_code[p.code] = p }
  end

  def [](code)
    @by_code.fetch(code) { raise ArgumentError, "Unknown product code: #{code}" }
  end
end
