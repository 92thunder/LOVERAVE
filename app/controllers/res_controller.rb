class ResController < ApplicationController
  def index
    user_id=params[:US]
    flash[:US]=user_id
  end
end
