class MicropostsController < ApplicationController
	before_filter :authenticate
	before_filter :authorized_user, :only => [:destroy]
	
	def create
		#the microposts object has a build method that is equivalent to calling Micropost.new, but passes in the id of the current user
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			redirect_to root_path, :flash => {:success => "Post successful"}
		else
			@feed_items = []
			render 'pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_path, :flash => {:success => "Micropost deleted" }
	end

	private
		def micropost_params
			params.require(:micropost).permit(:content, :user_id)
		end

		def authorized_user
			@micropost = Micropost.find(params[:id])
			redirect_to root_path unless current_user?(@micropost.user)
		end
end
