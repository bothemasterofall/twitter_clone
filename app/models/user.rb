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
	
	has_many :microposts, :dependent => :destroy	#a user's microposts are destroyed along with the user.
	has_many :relationships, :dependent => :destroy,
								:foreign_key => "follower_id"
	has_many :reverse_relationships, :dependent => :destroy,
										:foreign_key => "followed_id",
										:class_name => "Relationship"
	has_many :following, :through => :relationships, :source => :followed
	has_many :followers, :through => :reverse_relationships,
							:source => :follower
	
	email_regex = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i   #makes sure the email follows a certain pattern.
	
	validates :name, 		:presence => true,
							:length => { :maximum => 50 }
	validates :email, 		:presence => true,
							:format => { :with => email_regex },
							:uniqueness => true
	validates :password, 	:presence => true,
							:confirmation => true,
							:length => { :within => 6..40 }
	before_save :encrypt_password
	
	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
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
		relationships.find_by_followed_id(followed).destroy
	end
	
	def User.authenticate(email, submitted_password)
		this_user = User.find_by_email(email)
		(this_user && this_user.has_password?(submitted_password)) ? this_user : nil
	end
	
	def User.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
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
			secure_hash("#{Time.now.utc} -- #{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
