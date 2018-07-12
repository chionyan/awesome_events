module SystemSpecHelper
  def event_form_as(event)
    fill_in_text 'event_name', event.name
    fill_in_text 'event_place', event.place
    fill_in_text 'event_content', event.content
    select_datetime 'event_start_time', event.start_time
    select_datetime 'event_end_time', event.end_time
  end

  def fill_in_text(id_name, content)
    fill_in id_name, with: content
  end

  def select_datetime(id_name, datetime)
    select datetime.year.to_s, from: "#{id_name}_1i"
    select datetime.month.to_s, from: "#{id_name}_2i"
    select datetime.day.to_s, from: "#{id_name}_3i"
    select datetime.hour.to_s.rjust(2, '0'), from: "#{id_name}_4i"
    select datetime.min.to_s.rjust(2, '0'), from: "#{id_name}_5i"
  end
end
