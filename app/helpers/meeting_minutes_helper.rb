module MeetingMinutesHelper
  def controller_url
    "http://" + request.env["SERVER_NAME"] + ":" + request.env["SERVER_PORT"] + "/meeting_minutes" 
  end
end
