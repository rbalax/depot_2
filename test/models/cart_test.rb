require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "add unique products" do
    cart = Cart.create
    book_one = products(:one)
    book_two = products(:two)

    cart.add_product(book_one).save!
    cart.add_product(book_two).save!

    assert_equal 2, cart.line_items.size
    assert_equal book_one.price + book_two.price, cart.total_price
  end

  test "add duplicate product" do
    cart = Cart.create
    ruby_book = products(:ruby)

    3.times do
      cart.add_product(ruby_book).save!
    end

    assert_equal 1, cart.line_items.size
    assert_equal 3, cart.line_items.first.quantity
    assert_equal 3 * ruby_book.price, cart.total_price
  end

  test "add unique then duplicate product" do
    cart = Cart.create
    book_one = products(:one)
    ruby_book = products(:ruby)

    cart.add_product(book_one).save!
    cart.add_product(ruby_book).save!
    cart.add_product(ruby_book).save!

    assert_equal 2, cart.line_items.size
    ruby_item = cart.line_items.find_by(product_id: ruby_book.id)
    assert_equal 2, ruby_item.quantity
    assert_equal book_one.price + (2 * ruby_book.price), cart.total_price
  end
end
