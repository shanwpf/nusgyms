class OccupancyController < ApplicationController
  def get_json
    occupancies = helpers.average_json params[:gym_name]
    render json: occupancies
  end
end
