class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        flash[:info] = "thanks " + @user.name + ", you are successfully registered."
        log_in @user
        redirect_to root_url
      else
        render 'new'
      end
  end

  def edit
    if User.exists?(params[:id])
       @user = User.find(params[:id])
    else
        redirect_to edit_user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id]) if  User.exists?(params[:id])
        redirect_to(edit_user_path(current_user)) unless current_user == @user
    end

end
