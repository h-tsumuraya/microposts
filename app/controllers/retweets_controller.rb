class RetweetsController < ApplicationController
  def create
    current_user.do_retweet(params[:micropost_id])
    redirect_to :back # :backでページが切り替わらないようだ
  end

  def destroy
    current_user.del_retweet(params[:id])
    redirect_to :back
  end
end
