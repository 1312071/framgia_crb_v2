module EventsHelper
  def select_my_calendar calendars
    calendars.collect do |calendar|
      [calendar.name, calendar.id]
    end
  end

  def range_time_title event
    timezone = context_user.setting_timezone
    start_time_in_timezone = event.start_date.in_time_zone(timezone)

    return  start_time_in_timezone.strftime("%B %-d %Y") if event.all_day?

    finish_time_in_timezone = event.finish_date.in_time_zone(timezone)
    dname = start_time_in_timezone.strftime("%A")
    stime_name = start_time_in_timezone.strftime("%I:%M %p")
    ftime_name = finish_time_in_timezone.strftime("%I:%M %p")
    dtime_name = finish_time_in_timezone.strftime("%m-%d-%Y")
    dname + " " + stime_name + " To " + ftime_name + " " + dtime_name
  end
end
