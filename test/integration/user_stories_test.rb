require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
fixtures :products

LineItem.delete_all
Order.delete_all
ruby_book = product(:ruby)

get "/"
assert_response :success
assert_template "index"

xml_http_request :post, '/line_items' , :product_id => ruby_book.id
assert_response :success
cart = Cart.find(session[:cart_id])
assert_equal 1, cart.line_items.size
assert_equal ruby_book, cart.line_items[0].product

post_via_redirect "/orders" ,
:order => { :name => "Dave Thomas" ,
:address => "123 The Street" ,
:email => "ace.dimasuhid@yahoo.com" ,
:pay_type => "Check" }
assert_response :success
assert_template "index"
cart = Cart.find(session[:cart_id])
assert_equal 0, cart.line_items.size

orders = Order.find(:all)
assert_equal 1, orders.size
order = orders[0]
assert_equal "Dave Thomas" , order.name
assert_equal "123 The Street" , order.address
assert_equal "ace.dimasuhid@yahoo.com" , order.email
assert_equal "Check" , order.pay_type
assert_equal 1, order.line_items.size
line_item = order.line_items[0]
assert_equal ruby_book, line_item.product

end
