require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get check_in" do
    get :check_in
    assert_response :success
  end

  test "should get remove" do
    get :remove
    assert_response :success
  end

end
