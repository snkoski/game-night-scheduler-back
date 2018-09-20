class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: [:update, :show, :user_games, :user_groups, :sync_user_games]
  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :accepted
    else
      render json: { errors: @user.errors.full_message }, status: :unprocessible_entity
    end
  end

  def update
    @user.update(user_params)
    if @user.save
      render json: @user, status: :accepted
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def user_games
    render json: @user.games
  end

  def user_groups
    render json: @user.groups
  end

  def sync_user_games
    @user.sync_games(params['bgg_username'])
    render json: @user.games
  end

  private

  def user_params
    params.permit(:username, :email, :password, :bgg_username)
  end

  def find_user
    @user = User.find(params[:id])
  end
end