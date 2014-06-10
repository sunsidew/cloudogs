require 'test_helper'

class DocsHistoriesControllerTest < ActionController::TestCase
  setup do
    @docs_history = docs_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:docs_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create docs_history" do
    assert_difference('DocsHistory.count') do
      post :create, docs_history: { by_user_email: @docs_history.by_user_email, by_user_id: @docs_history.by_user_id, description: @docs_history.description, docs_id: @docs_history.docs_id, next_histroy_id: @docs_history.next_histroy_id, prev_histroy_id: @docs_history.prev_histroy_id }
    end

    assert_redirected_to docs_history_path(assigns(:docs_history))
  end

  test "should show docs_history" do
    get :show, id: @docs_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @docs_history
    assert_response :success
  end

  test "should update docs_history" do
    patch :update, id: @docs_history, docs_history: { by_user_email: @docs_history.by_user_email, by_user_id: @docs_history.by_user_id, description: @docs_history.description, docs_id: @docs_history.docs_id, next_histroy_id: @docs_history.next_histroy_id, prev_histroy_id: @docs_history.prev_histroy_id }
    assert_redirected_to docs_history_path(assigns(:docs_history))
  end

  test "should destroy docs_history" do
    assert_difference('DocsHistory.count', -1) do
      delete :destroy, id: @docs_history
    end

    assert_redirected_to docs_histories_path
  end
end
