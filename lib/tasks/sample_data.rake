require 'faker'

namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		make_users
		make_microposts
		make_relationships
	end
end

def make_users
	admin = User.create!(:name => "Example User", :email => "example0@example.com", :password => "example", :password_confirmation => "example")
	admin.toggle!(:admin)
	50.times do |n|
		name = Faker::Name.name
		email = "example#{n+1}@railstutorial.org"
		password = "password"
		User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
	end
end

def make_microposts
	User.all.each do |user|
		20.times do |i|
			user.microposts.create!(:content => Faker::Lorem.sentence(5))
		end
	end
end

def make_relationships
	users = User.all
	user = users.first
	following = users[1..20]
	followed = users [3..15]
	following.each { |followed| user.follow!(followed) }
	following.each { |follower| follower.follow!(user) }
end