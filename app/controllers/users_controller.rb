class UsersController < ApplicationController
	#makes it so you can't edit other user's info if you're not them
	before_filter :authenticate, :except => [:show, :new, :create]
	before_filter :correct_user, :only => [:edit, :update]

	def index
  		@users = User.paginate(:page => params[:page])
  		@title = "All users"
  	end

  	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			redirect_to @user, :flash => {:success => "Welcome to my Twitter Clone"}
		else
			@title = "Sign up"
			render 'new'
		end	
  	end

  	def new
	  	@user = User.new
	  	@title = "Sign up"
	end

  	def edit
  		@user = User.find(params[:id])
  		@title = "Edit user"
  	end

  	def show
	  	@user = User.find_by_id(params[:id])
	  	@title = @user.name
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to @user, :flash => {:success => "Info updated!"}
		else
			@title = "Edit user"
			render 'edit'
		end
	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		def authenticate
			deny_access unless signed_in?
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to root_path unless current_user?(@user)
		end
end