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
    render json: @dilemma.to_json(include: [:reasons])
  end

  def update
    @dilemma = Dilemma.find_by_id params[:id]
    if @dilemma.update_attributes name: params[:name], reasons_attributes: parse_reasons(params[:reasons])
      render json: @dilemma.to_json(include: [:reasons])
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

  def parse_reasons(reasons)
    reasons = reasons.map {|reason| JSON.parse(reason)}
    reasons.each {|reason| reason['type'] = reason['type'].to_sym}
  end
end

