require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  # test "the truth" do
  #   assert true
  # end

  test "user attributes must be not empty" do
  	user = User.new
  	assert user.invalid?
  	assert user.errors[:name].any?
  	assert user.errors[:password].any?
  end

  test "user name should be unique" do
  	user = users(:one)
  	user_a = User.new(name: user.name, password: 'secret')
  	assert user_a.invalid?
  	assert user_a.errors[:name].any?
  end
end
