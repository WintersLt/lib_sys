require 'test_helper'
class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

def setup
@user = User.new(name: "user1", email: "uesr1 @example.com", password: "user1_user1")
end

test "user should not be saved without name" do
#  user=User.new
  assert_not @user.save,"should not save without name"
end

test "user should not have blank email" do
#  user=User.new
@user.email=""
  assert_not @user.valid?, "user should not have blank email"
end

test "password field should be present" do
#  user=User.new
@user.password=""
  assert_not @user.valid?, "password field should be present"
end

test "email should not be more than 255 characters" do
  @user.email="abcdef"*50
  assert_not @user.valid?,"email should not be more than 255 characters"
end

test "user name may have whitespace in it"do
#  user=User.new
  @user.name="name space"
  assert_not @user.valid?,"Name may have whitespace in between"
end

test "user name can't have more than 50 characters"do
#  user=User.new
  @user.name="abc"*20
  assert_not @user.save ,"Name shouldn't have more than 50 charaters"
end

test "password should have minimum lenght of 6 characters" do
#user=User.new
@user.password="aaa"
assert_not @user.save, "Password minimum lenght not fulfilled"
end

test "email cannot have whitespace" do
#user=User.new
@user.email = 'user has space@gmail.com'
assert_not @user.valid?
end

test "email must have a domain name in it"do
@user.email="user email"
assert_not @user.valid?, "email must have a domain name"
end


end
