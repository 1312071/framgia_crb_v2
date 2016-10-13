class Api::CalendarsController < Api::BaseController
  respond_to :json

  def update
    user_calendar = current_user.user_calendars.find_by calendar_id: params[:id]
    if user_calendar.update_attributes color_id: params[:color_id]
      render text: t("calendars.flashs.updated")
    else
      render text: t("calendars.flashs.not_updated")
    end
  end
end
