class RegisterController < ApplicationController
  def index
    @user = User.new
  end

  def create
      if user_params[:first_name].blank?
        flash.now.alert = "First Name is missing"
        render :index
      end
      if user_params[:email].blank?
        flash.now.alert = "email is missing"
        render :index
      end
      if user_params[:email].blank?
        flash.now.alert = "Last Name is missing"
        render :index
      end
      if user_params[:phone].blank?
        flash.now.alert = "Phone is missing"
        render :index
      end
      if user_params[:password].blank?
        flash.now.alert = "Password is missing"
        render :index
      end
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        cookies[:token] = @user.token
        redirect_to admin_products_path
      else
        flash.now.alert = "Not Register"
        render :index
      end
  end
  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone)
  end
end
