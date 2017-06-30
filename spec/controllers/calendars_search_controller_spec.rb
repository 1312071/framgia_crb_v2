require "rails_helper"
require "devise"

RSpec.describe Calendars::SearchController do
  let!(:user){FactoryGirl.create :user}
  let(:calendar){FactoryGirl.create :calendar, owner: user, creator_id: user.id}

  before do
    sign_in user
    current_user = user
  end

  describe "GET #show" do
    context "render template calendars/search" do
      before{get :show, params: {}}
      it {expect(response).to render_template :show}
    end

    context "result with suggest time" do
      let(:event){FactoryGirl.build :event, calendar: calendar,
        start_date: Time.now - 2.hours, finish_date: Time.now - 1.hours}
      let(:search_params){params = {calendar: {ids: [calendar.id]},
        number_of_seats: 5, event_start_date: Time.now - 2.hours,
        event_finish_date: Time.now - 1.hours, start_date: event.start_date,
        start_time: event.start_date.to_datetime.utc,
        finish_time: event.finish_date.to_datetime.utc,
        finish_date: event.finish_date}}
      before{get :show, search_params}
      it "suggest time event" do
        expect(assigns(:results)).not_to be_empty
      end
    end

    context "no result" do
      let(:search_params){params = {calendar: {ids: [calendar.id]},
        number_of_seats: "12", event_start_date: "2017-06-30T18:30:00+09:00",
        event_finish_date: "2017-06-30T19:30:00+09:00",
        start_date: "30-06-2017", start_time: "6:30pm", finish_time: "7:30pm",
        finish_date: "30-06-2017"}}
      before{get :show, search_params}
      it "no result with calendars don't have event" do
        expect(assigns(:results)).not_to be_empty
      end
    end
  end
end
