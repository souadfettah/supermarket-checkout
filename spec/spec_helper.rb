# frozen_string_literal: true

require "rspec"

# Add lib to load path
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "money"
require "product"
require "catalog"
require "checkout"
require "pricing_rules/bogo_rule"
require "pricing_rules/bulk_price_drop_rule"
require "pricing_rules/fractional_price_rule"

RSpec.configure do |config|
  config.order = :random
end
