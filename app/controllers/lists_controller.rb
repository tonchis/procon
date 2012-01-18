class ListsController < ApplicationController
  before_filter :require_login
  respond_to :js, :json

  def index
    @lists = current_user.lists
  end

  def create
    @list = List.create name: params[:name], user: current_user
    render json: @list
  end

  def destroy
    @list = List.find_by_id params[:id]
    @list.destroy
    head 200
  end
end

