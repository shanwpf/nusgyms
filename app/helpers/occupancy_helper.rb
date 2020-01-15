module OccupancyHelper
  def average_json(gym_name)
    result = ActiveRecord::Base.connection.exec_query(
      "select cast(created_at as date) as date, date_part('hour', created_at) as hour, avg(#{gym_name})
        from occupancies
        group by cast(created_at as date), date_part('hour', created_at)
        order by cast(created_at as date), date_part('hour', created_at)"
    )
    result.each do |row|
      row['avg'] = row['avg'].to_f.round
    end
    result.to_json
  end
end
