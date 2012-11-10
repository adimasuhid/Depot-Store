class StoreController < ApplicationController
  def index
  	@products = Product.all
  	@time = Time.now
  	@cart = current_cart
  end
end
