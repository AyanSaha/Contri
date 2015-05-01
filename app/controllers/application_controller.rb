class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
<<<<<<< HEAD
private
helper_method :current_user
def current_user
  if session["access_token"]!= nil
       @current_user= session["access_token"] 
       
    end
    
=======
  helper_method :current_user
 
  private
 
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
>>>>>>> ccaeed13cb169915fe90c446bb71f39b86c9df21
  end
end

