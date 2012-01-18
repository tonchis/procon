class ListsController < ApplicationController
  before_filter :require_login
  respond_to :js, :json

  def index
    @lists = current_user.lists
  end

  def create
    if @list = List.create(name: params[:name], user: current_user)
      render json: @list
    else
      head 500
    end
  end

  def edit
    @list = List.find_by_id params[:id]
    render json: @list.to_json(include: [:items])
  end

  def update
    @list = List.find_by_id params[:id]
    if @list.update_attributes name: params[:name], items_attributes: parse_items(params[:items])
      render json: @list.to_json(include: [:items])
    else
      head 500
    end
  end

  def destroy
    @list = List.find_by_id params[:id]
    if @list.destroy
      head 200
    else
      head 500
    end
  end

private

  def parse_items(items)
    items = items.map {|item| JSON.parse(item)}
    items.each {|item| item['type'] = item['type'].to_sym}
  end
end

