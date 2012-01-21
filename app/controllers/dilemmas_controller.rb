class DilemmasController < ApplicationController
  before_filter :require_login
  respond_to :js, :json

  def index
    @dilemmas = current_user.dilemmas
    render json: dilemmas_with_reasons_json(@dilemmas) if request.xhr?
  end

  def create
    if @dilemma = Dilemma.create(name: params[:name], user: current_user)
      render json: @dilemma
    else
      head 500
    end
  end

  def update
    @dilemma = Dilemma.find_by_id params[:id]
    if @dilemma.update_attributes name: params[:name], reasons_attributes: parse_reasons(params[:reasons])
      render json: @dilemma.to_json(include: :reasons)
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

  # This hack is to include Reason#type.
  # For some reason, it gets excluded if I just call
  # dilemmas.to_json(include: :reasons)
  # It's probably because of the STI thing.
  def dilemmas_with_reasons_json(dilemmas)
    dilemmas.to_json(include: {reasons: {only: [:id, :text, :type]}})
  end
end

