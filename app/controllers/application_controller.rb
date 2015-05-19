class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  helper_method :current_user

  def current_user
    if session["access_token"]!= nil
      @current_user= session["access_token"]

    end
  end
end

