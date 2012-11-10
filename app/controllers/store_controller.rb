class StoreController < ApplicationController
	skip_before_filter :authorize
  def index
  	@products = Product.all
  	@time = Time.now
  	@cart = current_cart
  end
end
