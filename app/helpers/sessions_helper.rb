module SessionsHelper
	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user?(user)
		user == current_user
	end

	def current_user
		#instance vars only last per page. 
		#this || makes it persist, so you stay signed in until page is closed.
		@current_user ||= user_from_remember_token 
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete :remember_token
		@current_user = nil
	end

	def deny_access
		store_location
		redirect_to new_session_path, :notice => "Must be signed in to access this page"
	end
	
	def store_location
		session[:return_to] = request.fullpath
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end

	def clear_return_to
		session[:return_to] = nil
	end

	private
		def user_from_remember_token
			#authenticate_with_salt takes two arguments. the star * allows it to accept the return values from remember_token
			User.authentiate_with_salt(*remember_token)
		end

		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end
end