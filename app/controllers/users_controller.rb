class UsersController < ApplicationController
	before_filter :authenticate, :except => [:show, :new, :create]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => [:destroy]
	
	def index
		@users = User.paginate(:page => params[:page])
		@title = "All users"
	end
	
	def show
		@user = User.find(params[:id]) # url is /users/insert id number here
		@microposts = @user.microposts.paginate(:page => params[:page])
		@title = @user.name
	end
	
	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.following.paginate(:page => params[:page])
		render 'show_follow'
	end
	
	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(:page => params[:page])
		render 'show_follow'
	end

	def new
		@user = User.new
		@title = "Sign Up"
	end
	
	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			redirect_to @user, :flash => {:success => "Welcome to the Sample App!"}
		else
			@title = "Sign up"
			render 'new'
		end
	end
	
	def edit
		@user = User.find(params[:id])
		@title = "Edit user"
	end
	
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			#it worked
			redirect_to @user, :flash => { :succes => "Profile updated" }
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	def destroy
		User.find(params[:id]).destroy
		redirect_to users_path, :flash => { :succes => "User destroyed" }
	end
	
	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
	
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end
	
	def admin_user
		user = User.find(params[:id])
		redirect_to(root_path) unless (current_user.admin? && !current_user?(user))
	end
end
