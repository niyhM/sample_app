require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup information" do 
		get signup_path
		assert_select 'form[action="/signup"]'
		assert_no_difference 'User.count' do 
			post users_path, params: {user: { name: "",
											  email: "user@invalid",
											  password:             "foo",
											  password_confirmation:"bar"}}
		end
		assert_template 'users/new'
		assert_select 'div.field_with_errors', count: 4*2
		assert_select 'div#error_explanation' 
	end

	test "valid signup" do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, params: {user: { name: "Example User",
											  email: "user@example.com",
											  password:             "password",
											  password_confirmation:"password"}}
 		end
 		follow_redirect!
 		assert_template 'users/show'
 		assert_not flash[:success].empty?
 		user = User.find_by(name: "Example User", email: "user@example.com")
 		assert_not user.blank?
 		get user_path(user)
 		assert flash[:success].blank?
 	end
end
