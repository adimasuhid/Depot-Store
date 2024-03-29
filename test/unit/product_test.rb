require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :products

  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
  	product = Product.new(:title => "My Book Title",
  						  :description => "yyy",
  						  :image_url => "zzz.jpg")
  	product.price = -1
  	assert product.invalid?
  	assert_equal "must be greater than or equal to 0.01",
  		product.errors[:price].join('; ')

  	product.price = 0
  	assert product.invalid?
  	assert_equal "must be greater than or equal to 0.01",
  		product.errors[:price].join('; ')

  	product.price = 1
  	assert product.valid?
  end

  def new_product(image_url)
  	Product.new(:title 			=> "My Book Title",
  				:description 	=> "yyy",
  				:price 			=> 1,
  				:image_url 		=> image_url)
  end

  test "image url" do
  	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.jpg
  				http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more fred.gif.more }

  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} shouldn't be invalid"
  	end

  	bad.each do |name|
  		assert new_product(name).invalid?, "#{name} shouldn't be valid"
  	end
  end

  test "product is not valid without a unique title" do
  	product = Product.new(:title 		=> products(:ruby).title,
  						  :description	=> "yyy",
  						  :price		=> 1,
  						  :image_url	=> "fred.gif")
  	assert !product.save
  	assert_equal "has already been taken", product.errors[:title].join('; ')
  end

  test "title length must be 1 or more" do
   	product = Product.new(:price => 1,
  						  :description => "yyy",
  						  :image_url => "zzz.jpg") 	
   	product.title = "6 only"
   	assert product.title.length < 10, "product title should be 10 or more"
   end

  test "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', :minimum => 4
    assert_select '.list_actions', 3
  end
end
