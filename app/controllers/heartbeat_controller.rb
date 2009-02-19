class HeartbeatController < ApplicationController
  def index
    if !ActionStatus.exists?(10)
      render :inline => "something is wrong", :status => 500
    end
  end
end
