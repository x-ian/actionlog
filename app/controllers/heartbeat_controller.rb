class HeartbeatController < ApplicationController
  def index
    if !ActionStatus.exists?(1)
      render :inline => "something is wrong", :status => 500
    end
  end
end
