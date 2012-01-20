class DilemmasController < ApplicationController
  before_filter :require_login
  respond_to :js, :json

  def index
    @dilemmas = current_user.dilemmas
  end

  def create
    if @dilemma = Dilemma.create(name: params[:name], user: current_user)
      render json: @dilemma
    else
      head 500
    end
  end

  def edit
    @dilemma = Dilemma.find_by_id params[:id]
    render json: @dilemma.to_json(include: [:items])
  end

  def update
    @dilemma = Dilemma.find_by_id params[:id]
    if @dilemma.update_attributes name: params[:name], items_attributes: parse_items(params[:items])
      render json: @dilemma.to_json(include: [:items])
    else
      head 500
    end
  end

  def destroy
    @dilemma = Dilemma.find_by_id params[:id]
    if @dilemma.destroy
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

