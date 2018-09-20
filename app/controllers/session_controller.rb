class SessionController < ApplicationController

  def indx
  end

  def session_in
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      cookies[:token] = user.token
      redirect_to admin_products_path
    else
      flash.now.alert = "Email or password is invalid"
      render :index
    end
  end

  def session_out
    session[:user_id] = nil
    cookies[:token] = nil
    redirect_to login_path
  end
end
