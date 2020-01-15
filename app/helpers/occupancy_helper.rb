module OccupancyHelper
  def average_json(gym_name)
    result = ActiveRecord::Base.connection.exec_query(
      "select cast(created_at as date) as date, date_part('hour', created_at) as hour, avg(#{gym_name})
        from occupancies
        group by cast(created_at as date), date_part('hour', created_at)
        order by cast(created_at as date), date_part('hour', created_at)"
    ).entries
    puts result
    result.to_json
  end
end
