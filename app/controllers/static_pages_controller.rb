class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed_items.includes(:user)
                    .order(created_at: :desc).page(params[:page])
      @is_feed = true
    end
  end

  def help

  end
end
