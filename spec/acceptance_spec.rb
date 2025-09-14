# frozen_string_literal: true

RSpec.describe "Acceptance scenarios" do
  let(:products) do
    [
      Product.new(code: "GR1", name: "Green tea",    price: "3.11"),
      Product.new(code: "SR1", name: "Strawberries", price: "5.00"),
      Product.new(code: "CF1", name: "Coffee",       price: "11.23")
    ]
  end
  let(:catalog) { Catalog.new(products) }
  let(:rules) do
    [
      BogoRule.new("GR1"),
      BulkPriceDropRule.new(code: "SR1", threshold: 3, new_price: "4.50"),
      FractionalPriceRule.new(code: "CF1", threshold: 3, numerator: 2, denominator: 3)
    ]
  end

  def checkout_for(codes)
    co = Checkout.new(pricing_rules: rules, catalog: catalog)
    codes.each { |c| co.scan(c) }
    co
  end

  it "Basket: GR1,SR1,GR1,GR1,CF1 -> £22.45" do
    co = checkout_for(%w[GR1 SR1 GR1 GR1 CF1])
    expect(co.total_formatted).to eq("£22.45")
  end

  it "Basket: GR1,GR1 -> £3.11" do
    co = checkout_for(%w[GR1 GR1])
    expect(co.total_formatted).to eq("£3.11")
  end

  it "Basket: SR1,SR1,GR1,SR1 -> £16.61" do
    co = checkout_for(%w[SR1 SR1 GR1 SR1])
    expect(co.total_formatted).to eq("£16.61")
  end

  it "Basket: GR1,CF1,SR1,CF1,CF1 -> £30.57" do
    co = checkout_for(%w[GR1 CF1 SR1 CF1 CF1])
    expect(co.total_formatted).to eq("£30.57")
  end
end
