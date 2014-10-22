# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	attr_accessor :password

	#everything the web needs to access needs to be on this line
	attr_accessible :name, :email, :password, :password_confirmation

	has_many :microposts, 	:dependent => :destroy 	#a user's microposts are destroyed along with the user.
	has_many :relationships, 	:dependent => :destroy,
								:foreign_key => "follower_id"
	has_many :reverse_relationships, 	:dependent => :destroy,
										:foreign_key => "followed_id",
										:class_name => "Relationship"
	has_many :following, 	:through => :relationships,
							:source => :followed
	has_many :followers, 	:through => :reverse_relationships,
							:source => :follower

	email_regex = /\A[a-z\.\d]+@[a-z\.\d]+\.[a-z]+\z/i

	validates :name, :presence => true,
		:length => {:maximum => 50}
	validates :email, :presence => true,
		:format => {:with => email_regex},
		:uniqueness => {case_sensitive: false}
	validates :password, :presence => true,
		:confirmation => true,	#creates the password_confirmation attribute
		:length => {:minimum => 6}

	#executes the methods before the user is saved
	before_save :encrypt_password 

	def has_password?(pass)
		self.encrypted_password == encrypt(pass)
	end

	def feed
		Micropost.from_users_followed_by(self)
	end

	def following?(followed)
		relationships.find_by_followed_id(followed)
	end

	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end

	def unfollow!(following)
		relationships.find_by_followed_id(following).destroy
	end

	class << self
		def authenticate(email, sub_pass)	
			user = find_by_email(email)
			return nil if user.nil?
			return user if user.has_password?(sub_pass)
		end

		def authentiate_with_salt(id, cookie_salt)
			user = find_by_id(id)
			(!user.nil? && user.salt == cookie_salt) ? user : nil
		end
	end

	private
		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
