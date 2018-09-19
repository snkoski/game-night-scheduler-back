class Api::V1::GroupsController < ApplicationController
  before_action :find_group, only: [:update, :show, :group_users]
  def index
    @groups = Group.all
    render json: @groups
  end

  def show
    render json: @group
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      render json: @group, status: :accepted
    else
      render json: { errors: @group.errors.full_message }, status: :unprocessible_entity
    end
  end

  def update
    @group.update(group_params)
    if @group.save
      render json: @group, status: :accepted
    else
      render json: { errors: @group.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def group_users
    render json: @group.users
  end

  private

  def group_params
    params.permit(:name, :number_of_members, :regular_meeting_day)
  end

  def find_group
    @group = Group.find(params[:id])
  end
end
