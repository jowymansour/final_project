require 'test_helper'

class CtaScheduleControllerTest < ActionController::TestCase
  test "should get new_search" do
    get :new_search
    assert_response :success
  end

end
