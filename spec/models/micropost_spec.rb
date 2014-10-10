# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Micropost, :type => :model do
	describe "from_users_followed_by" do
		before(:each) do
			@other_user = Factory(:user, :email => Factory.next(:email))
			@third_user = Factory(:user, :email => Factory.next(:email))
			
			@user_post = @user.microposts.create!(:content => "test1")
			@other_post = @other_user.microposts.create!(:content => "test2")
			@third_post = @third_user.microposts.create!(:content => "test3")
			
			@user.follow!(@other_user)
		end
		
		it "should have a from_users_followed_by method" do
			Micropost.should respond_to(:from_users_followed_by)
		end
		
		it "should include the followed user's microposts" do
			Micropost.from_users_followed_by(@user).should include(@other_post)
		end
		
		it "should include the user's own microposts" do
			Micropost.from_users_followed_by(@user).should include(@user_post)
		end
		
		it "should not include an unfollowed user's microposts"
			Micropost.from_users_followed_by(@user).should_not include(@third_post)
		end
	end
end
