class UsersController < ApplicationController

  def show
    # findだとユーザーが見つからなかったらerrorをはくので、find_by_idに
    @user = User.find_by_id(params[:id])

    # @userがnilならばルートへ飛ばす
    if @user.nil?
      flash[:warning] = "cannot find user.. (invalid user_id)"
      return redirect_to root_path
    end

    @microposts = @user.microposts.order(created_at: :desc).page(params[:page])

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
      session[:user_id] = @user.id # セッションに追加してログイン状態にする
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])

    # 他のユーザーのプロフィールは編集できない
    unless @user == current_user
      flash[:warning] = "cannot edit other user's profile."
      redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])

    # 他のユーザーのプロフィールは編集できない
    unless @user == current_user
      flash[:warning] = "cannot edit other user's profile."
      return redirect_to root_path
    end

    if @user.update(user_params_update)
      flash[:success] = "profile update success!"
      redirect_to @user
    else
      render :edit
    end
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.following_users.all
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.follower_users.all
  end

  def favs
    @microposts = current_user.favorite_microposts
  end

  def all
    @users = User.all
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
