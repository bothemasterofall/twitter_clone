# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessor :password

	#everything the web needs to access needs to be on this line
	attr_accessible :name, :email, :password, :password_confirmation

	email_regex = /\A[a-z\.\d]+@[a-z\.\d]+\.[a-z]+\z/i

	validates :name, :presence => true,
		:length => {:maximum => 16}
	validates :email, :presence => true,
		:format => {:with => email_regex},
		:uniqueness => {case_sensitive: false}
	validates :password, :presence => true,
		:confirmation => true,	#creates the password_confirmation attribute
		:length => {:minimum => 6}
end