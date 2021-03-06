class RelationshipsController < ApplicationController

before_action :logged_in_user

  def create
  	@user = User.find(params[:followed_id])
    current_user.follow(@user)

    Pusher.trigger("mychannel-#{@user.id}", 'my-event', {:type => "new_follower", :name=> current_user.name, :url => @user.gravatar_url })
    @notify = @user.notify("#{@user.name}님이 #{current_user.name}님을 팔로잉합니다" , "/users/1/followers") 
    @notify.save! 
     respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
  	@user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end

  end
end