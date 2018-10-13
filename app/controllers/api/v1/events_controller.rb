class Api::V1::EventsController < ApplicationController
  before_action :find_event, only: [:update, :show, :event_users]
  # def index
  #   @events = Event.all
  #   render json: @events
  # end

  def index
  if params[:group_id]
    @events = Group.find(params[:group_id]).events
    render json: @events
  else
    @events = Event.all
    render json: @events
  end
end

  def show
    render json: @event
  end

  def create
    user = User.find(params[:created_by])
    @event = Event.new(event_params)
    if @event.save
      @event.users << user
      render json: @event, status: :accepted
    else
      render json: { errors: @event.errors.full_message }, status: :unprocessible_entity
    end
  end

  def update
    @event.update(event_params)
    if @event.save
      render json: @event, status: :accepted
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def event_users
    render json: @event.users
  end

  private

  def event_params
    params.permit(:name, :date, :time, :created_by, :group_id)
  end

  def find_event
    @event = Event.find(params[:id])
  end
end
