class RetweetsController < ApplicationController
  before_action :logged_in_user

  def create
    @id = params[:micropost_id]
    current_user.do_retweet(@id)
    @micropost = Micropost.find(@id)
  end

  def destroy
    @id = params[:id]
    @is_feed = params[:is_feed].to_i == 1 # もうちょっとうまい方法はないものか…
    current_user.del_retweet(@id)
    micropost = Micropost.find(@id)

    # feedでフォローしていないユーザーの投稿なら消す必要があるため、何も返さない
    if @is_feed && !current_user.following?(micropost.user)
      return
    end

    @micropost = micropost
  end
end
