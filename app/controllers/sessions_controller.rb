class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to_path
      flash[:error] = "You are already logged in"
    end
  end




  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.role == "default"
        redirect_to '/profile'
        flash[:success] = "You are now registered and logged in"
      elsif user.role == "merchant"
        redirect_to '/merchant'
        flash[:success] = "You are now registered and logged in"
      else user.role == "admin"
        redirect_to '/admin'
        flash[:success] = "You are now registered and logged in"
      end
    else
      flash[:error] = "Sorry, your credentials are invalid"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:error] = "You have logged out"
    redirect_to "/"
  end

  private

  def redirect_to_path
    current_user = User.find(session[:user_id])

    if current_user.role == "default"
      redirect_to "/profile"
    elsif current_user.role == "merchant"
      redirect_to '/merchant'
    else current_user.role == "admin"
      redirect_to '/admin'
    end
  end

end
