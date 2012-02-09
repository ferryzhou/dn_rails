require 'test_helper'

class GitemsControllerTest < ActionController::TestCase
  setup do
    @gitem = gitems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gitems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gitem" do
    assert_difference('Gitem.count') do
      post :create, gitem: @gitem.attributes
    end

    assert_redirected_to gitem_path(assigns(:gitem))
  end

  test "should show gitem" do
    get :show, id: @gitem.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gitem.to_param
    assert_response :success
  end

  test "should update gitem" do
    put :update, id: @gitem.to_param, gitem: @gitem.attributes
    assert_redirected_to gitem_path(assigns(:gitem))
  end

  test "should destroy gitem" do
    assert_difference('Gitem.count', -1) do
      delete :destroy, id: @gitem.to_param
    end

    assert_redirected_to gitems_path
  end
end
