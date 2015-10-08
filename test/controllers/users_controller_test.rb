require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

def setup
@user = User.new(name: "user1", email: "uesr1@example.com", password: "user1_user1");
@admin= User.new(name: "admin", email: "admin@admin.com", password: "admin_admin");
end

test "should get new" do
get :new
assert_response :success
end


test "should get index" do
get :index
assert_response :success
end

test "show admin when logged is an admin" do
    @admin.save
    log_in(@admin,is_admin)
    get :show, id: @admin
    assert_response :success
end

test "should allow admin to see all the users" do
@admin.save
log_in(@admin,is_admin)
get:edit, id:@admin
asser_response:success
end

end
