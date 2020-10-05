class RelationshipsController < ApplicationController
  def follow
  	@user = User.find(params[:id])
  	current_user.follow(@user.id)
  	# current_user.follow(params[:id])
  	# redirect_to request.referrer
  end

  def unfollow
  	@user = User.find(params[:id])
  	current_user.unfollow(@user.id)
  	# current_user.unfollow(params[:id])
  	# redirect_to request.referrer
  end
end
