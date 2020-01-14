class OccupancyController < ApplicationController
  def get_json
    occupancies = helpers.average_json
    render json: occupancies
  end
end
