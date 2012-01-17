class ListsController < ApplicationController
  before_filter :require_login

  def index
    @lists = current_user.lists
  end

  def create
    @list = List.create name: params[:name], user: current_user
    redirect_to edit_list_url(@list)
  end

  def edit
  end
end

