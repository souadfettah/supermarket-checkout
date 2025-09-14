# frozen_string_literal: true

RSpec.describe "Pricing Rules" do
  let(:products) do
    [
      Product.new(code: "GR1", name: "Green tea",    price: "3.11"),
      Product.new(code: "SR1", name: "Strawberries", price: "5.00"),
      Product.new(code: "CF1", name: "Coffee",       price: "11.23")
    ]
  end
  let(:catalog) { Catalog.new(products) }

  it "applies BOGO for GR1" do
    rule = BogoRule.new("GR1")
    counts = { "GR1" => 5 }
    expect(rule.discount_for(counts, catalog)).to eq(-(Money.dec("3.11") * 2))
  end

  it "applies bulk price drop for SR1 (>=3 to £4.50)" do
    rule = BulkPriceDropRule.new(code: "SR1", threshold: 3, new_price: "4.50")
    counts = { "SR1" => 3 }
    expect(rule.discount_for(counts, catalog)).to eq(-(Money.dec("0.50") * 3))
  end

  it "applies fractional price drop for CF1 (>=3 to 2/3 of original)" do
    rule = FractionalPriceRule.new(code: "CF1", threshold: 3, numerator: 2, denominator: 3)
    counts = { "CF1" => 3 }
    old = Money.dec("11.23")
    new_price = old * 2 / 3
    expect(rule.discount_for(counts, catalog)).to eq(-((old - new_price) * 3))
  end
end
