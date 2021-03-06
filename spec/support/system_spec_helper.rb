module SystemSpecHelper
  def select_datetime(id_name, datetime)
    select datetime.year.to_s, from: "#{id_name}_1i"
    select datetime.month.to_s, from: "#{id_name}_2i"
    select datetime.day.to_s, from: "#{id_name}_3i"
    select datetime.hour.to_s.rjust(2, '0'), from: "#{id_name}_4i"
    select datetime.min.to_s.rjust(2, '0'), from: "#{id_name}_5i"
  end
end
