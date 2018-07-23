class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :ticket?

  private

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    !!session[:user_id]
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: 'ログインしてください'
  end

  def ticket?(event)
    current_user.events.include?(event)
  end
end
