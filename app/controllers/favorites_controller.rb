class FavoritesController < ApplicationController
  def create
    @id = params[:micropost_id]
    micropost = Micropost.find_by_id(@id)
#    micropost = Micropost.find(params[:micropost_id]) # こっちでもいける
    current_user.add_to_fav(micropost)
  end

  def destroy
    @id = params[:id]
    micropost = Micropost.find_by_id(@id)
    current_user.del_from_fav(micropost)
  end
end
