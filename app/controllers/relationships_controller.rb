class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id]) #フォローされるユーザー
    current_user.follow(@user) #フォローする
  end

  def destroy
    @user = current_user.following_relationships.find(params[:id]).followed
    current_user.unfollow(@user) #アンフォローする
  end

end
