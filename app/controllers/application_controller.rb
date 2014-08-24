class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  before_filter :user

  def user
    @user ||= current_or_guest_user
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        convert_guest_to_current(guest_user)
      end
      current_user
    else
      guest_user
    end
  end

  def guest_user
    @cached_guest_user ||= (User.find_by_id(session[:guest_user_id]) || create_guest_user)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     Rails.logger.debug "Couldn't find user using session =#{session[:guest_user_id]}"
     session[:guest_user_id] = nil
     guest_user
  end

  def user_registered?
    !/guest/.match(@user.email)
  end

  private

  def convert_guest_to_current(guest_user)
    if current_user.sign_in_count <= 1
      current_user.user_companies = guest_user.user_companies.dup
      current_user.save!
      guest_user.destroy
      session[:guest_user_id] = nil
    end
  end

  def create_guest_user
    u = User.new(:email => "guest_#{Time.now.to_i}#{rand(99)}@vcn.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

end
