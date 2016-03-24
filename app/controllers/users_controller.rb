class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])

    @microposts = @user.microposts.order(created_at: :desc)

    # 性別の文字列セット
    case @user.gender.to_i
    when 1
      @gender_str = "男性"
    when 2
      @gender_str = "女性"
    else
      @gender_str = "秘密"
    end
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
    logger.debug(session[:user_id])
    logger.debug(params[:id])
    if session[:user_id].to_s == params[:id]
      @user = User.find(params[:id])
    else
      flash[:warning] = "cannot edit other user's profile."
      redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params_update)
      flash[:success] = "profile update success!"
      redirect_to @user
    else
      render :edit
    end
  end

  def followings
    @user = User.find(params[:user_id])
    @followings = @user.following_users.all
  end

  def followers
    @user = User.find(params[:user_id])
    @followers = @user.follower_users.all
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def user_params_update
    params.require(:user).permit(:name, :email, :profile, :location, :gender)
  end

end
