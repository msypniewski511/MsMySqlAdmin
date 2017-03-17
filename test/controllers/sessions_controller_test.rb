require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should prompt for login" do
    get login_url
    assert_response :success
  end

  test "should login" do
    maciej = users(:one)
    post login_url, params: { name: maciej.name, password: 'secret' }
    assert_response :redirect
    assert_equal maciej.id, session[user_id]
  end

  test "should not login" do
    maciej = users(:one)
    post login_url, params: { name: maciej.name, password: "incorect"}
    assert_redirected_to login_url
  end

  test "should logout" do
    delete logout_url
    assert_redirected_to root_url
  end

end
