class ListsController < ApplicationController
  before_filter :require_login

  def index
    @lists = current_user.lists
  end
end

