class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @property = Property.find(params[:property_id])
    favorite = current_user.favorites.find_or_create_by(property: @property)

    respond_to do |format|
      format.html { redirect_to @property, notice: "Added to favorites" }
      format.turbo_stream
    end
  end

  def destroy
    @property = Property.find(params[:property_id])
    current_user.favorites.where(property: @property).destroy_all

    respond_to do |format|
      format.html { redirect_to @property, notice: "Removed from favorites" }
      format.turbo_stream
    end
  end
end
