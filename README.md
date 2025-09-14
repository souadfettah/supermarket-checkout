# Supermarket Checkout

A simple Ruby supermarket checkout system built with **Test-Driven Development (TDD)**. It supports flexible pricing rules, scans items in any order, and calculates correct totals.

---

## Table of Contents

* [Features](#features)
* [Products](#products)
* [Pricing Rules](#pricing-rules)
* [How It Works](#how-it-works)
* [Example Baskets](#example-baskets)
* [Installation](#installation)
* [Running Tests](#running-tests)
* [CLI (`bin/checkout`)](#cli-bincheckout)

  * [Installation](#installation-1)
  * [Usage](#usage)
  * [Options](#options)
  * [Examples](#examples)
  * [Interactive mode](#interactive-mode)
* [Products & Rules](#products--rules)
* [Project Structure](#project-structure)
* [Development Notes](#development-notes)

---

## Features

* Modular Ruby
* Clean `Checkout` class with pluggable pricing rules
* Money handling with `BigDecimal` for accuracy
* RSpec test suite covering rules, checkout, and acceptance baskets
* CLI tool (`bin/checkout`) for manual scans

## Products

|    Code | Name         |  Price |
| ------: | ------------ | -----: |
| **GR1** | Green tea    |  £3.11 |
| **SR1** | Strawberries |  £5.00 |
| **CF1** | Coffee       | £11.23 |

## Pricing Rules

* **GR1 (Green tea)**: Buy One, Get One Free
* **SR1 (Strawberries)**: If 3 or more, price drops to £4.50 each
* **CF1 (Coffee)**: If 3 or more, price drops to two-thirds each

## How It Works

Create a `Checkout` with a set of pricing rules. Scan items in any order; totals are computed with exact decimal math.

```ruby
require "bigdecimal"

products = {
  "GR1" => BigDecimal("3.11"),
  "SR1" => BigDecimal("5.00"),
  "CF1" => BigDecimal("11.23")
}

rules = [
  Rules::Bogof.new(code: "GR1"),
  Rules::BulkPriceDrop.new(code: "SR1", min_qty: 3, new_price: BigDecimal("4.50")),
  Rules::FactorDiscount.new(code: "CF1", min_qty: 3, factor: BigDecimal("2.0")/3)
]

co = Checkout.new(rules: rules, catalog: products)
%w[GR1 SR1 GR1 GR1 CF1].each { |code| co.scan(code) }

puts Formatter.pretty_pounds(co.total) # => "£22.45"
```

> **Note:** Money is represented as `BigDecimal` internally and only rounded for display.

## Example Baskets

* Basket: `GR1, SR1, GR1, GR1, CF1` → **£22.45**
* Basket: `GR1, GR1` → **£3.11**
* Basket: `SR1, SR1, GR1, SR1` → **£16.61**
* Basket: `GR1, CF1, SR1, CF1, CF1` → **£30.57**

## Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/souadfettah/supermarket-checkout.git
cd supermarket-checkout
bundle install
```

## Running Tests

The project is fully test-driven. Run the RSpec suite:

```bash
bundle exec rspec
```

All acceptance baskets and unit rules are covered.

## CLI (`bin/checkout`)

A small command-line tool lets you scan items and get the total. It works in two modes:

* **Arguments**: pass product codes directly on the command line
* **Interactive**: run without arguments and type codes one by one, then enter `total`

### Installation

```bash
mkdir -p bin
# create the bin/checkout file with the script content
chmod +x bin/checkout
```

### Usage

```bash
bin/checkout GR1 SR1 CF1           # compute the total for given codes
bin/checkout                        # start in interactive mode
```

### Options

* `-r, --raw` : print the raw BigDecimal total instead of "£xx.xx"
* `-h, --help` : show help

### Examples

```bash
bin/checkout GR1 SR1 GR1 GR1 CF1
# => £22.45

bin/checkout GR1 GR1
# => £3.11
```

### Interactive mode

```
$ bin/checkout
Supermarket Checkout — interactive mode
Type 'help' for help. Products: GR1 (3.11), SR1 (5.00), CF1 (11.23).
> GR1
Added: GR1
> SR1
Added: SR1
> GR1
Added: GR1
> GR1
Added: GR1
> CF1
Added: CF1
> total
Basket: GR1, SR1, GR1, GR1, CF1
£22.45
> quit
Goodbye!
```

## Products & Rules

The CLI uses the same products and rules as the test suite:

* **GR1** (Green tea) £3.11 — *Buy One, Get One Free*
* **SR1** (Strawberries) £5.00 — *3 or more → £4.50 each*
* **CF1** (Coffee) £11.23 — *3 or more → two-thirds price each*

## Project Structure

```
├─ bin/
│  └─ checkout        # CLI entrypoint
├─ lib/
│  ├─ checkout.rb     # Checkout class
│  ├─ rules/          # Pricing rule classes
│  └─ utils/          # Money/format helpers
├─ spec/
│  ├─ acceptance/     # End-to-end basket specs
│  ├─ rules/          # Unit tests for rules
│  └─ checkout_spec.rb
└─ README.md
```

> Structure may vary slightly; adjust filenames to match your codebase.

## Development Notes

* Code is organized under `lib/` and `spec/`.
* Pricing rules are separate classes and can be extended easily.
* Money is always stored as `BigDecimal` and only rounded for display.
