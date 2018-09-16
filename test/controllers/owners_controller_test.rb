require 'test_helper'

class OwnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = owners(:one)
  end

  test "should get index" do
    get owners_url
    assert_response :success
  end

  test "should get new" do
    get new_owner_url
    assert_response :success
  end

  test "should create owner" do
    assert_difference('Owner.count') do
      post owners_url, params: { owner: { avatar_url: @owner.avatar_url, html_url: @owner.html_url, login: @owner.login, nodeid: @owner.nodeid, type_id: @owner.type_id } }
    end

    assert_redirected_to owner_url(Owner.last)
  end

  test "should show owner" do
    get owner_url(@owner)
    assert_response :success
  end

  test "should get edit" do
    get edit_owner_url(@owner)
    assert_response :success
  end

  test "should update owner" do
    patch owner_url(@owner), params: { owner: { avatar_url: @owner.avatar_url, html_url: @owner.html_url, login: @owner.login, nodeid: @owner.nodeid, type_id: @owner.type_id } }
    assert_redirected_to owner_url(@owner)
  end

  test "should destroy owner" do
    assert_difference('Owner.count', -1) do
      delete owner_url(@owner)
    end

    assert_redirected_to owners_url
  end
end
