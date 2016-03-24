class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
    # logger.debug("sessionのuser_id #{session[:user_id]}")
    # logger.debug("paramsのid #{params[:id]}")
    # if session[:user_id] == params[:id]
    #   logger.debug("OK")
    #   @user = User.find(params[:id])
    # else
    #   logger.debug("NG")
    #   redirect_to root_path
    # end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params_update)
      flash[:success] = "成功"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def user_params_update
    params.require(:user).permit(:name, :email, :profile)
  end

end
