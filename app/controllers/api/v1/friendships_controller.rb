class Api::V1::FriendshipsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @friendships = @user.friendships
    # @friendships = @user.friendships.map do |f|
    #   f.friend
    # end
    render json: @friendships
  end

  def create
    @user = User.find(params[:user_id])
    @friendship = @user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      render json: @friendship, status: :accepted
    else
      render json: { errors: @friendship.errors.full_message }, status: :unprocessible_entity
    end
  end

  def destroy
    byebug
    @user = User.find(params[:user_id])
    @friendship = @user.friendships.find(params[:id])
    @friendship.destroy
    render json: @friendship
  end

  def get_user_friends
    @user = User.find(params[:id])
    @friends = @user.friendships.map do |f|
      f.friend
    end
    render json: @friends

  end


end
