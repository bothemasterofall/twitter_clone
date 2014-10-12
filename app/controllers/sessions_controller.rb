class SessionsController < ApplicationController
	def new
	  	@title = "Sign in"
	end

	def create
		user = User.authenticate(params[:session][:email],
			params[:session][:password])
		if user.nil?
			flash.now[:error] = "Invalid email/password combination" #flash.now persists only for this request
			render 'new'
		else
			sign_in user
			redirect_to user
		end
	end

	def destroy
		current_user = nil
		redirect_to root_path
	end
end