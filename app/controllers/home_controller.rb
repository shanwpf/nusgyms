class HomeController < ApplicationController
  def index
    @occupancies = Occupancy.order("created_at DESC").first
  end
end
