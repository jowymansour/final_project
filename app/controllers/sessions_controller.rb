class SessionsController < ApplicationController


  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
    elsif  !user
      flash.now[:danger] = 'Invalid email'
      render 'new'
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def facebook
    user = User.from_omniauth(env["omniauth.auth"])
    if user
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = 'Error, please try again.'
      render 'new'
    end
  end



  def destroy
    log_out if logged_in?
    flash[:info] = 'You are successfully disconnected, see you soon!'
    redirect_to root_url
  end

end
