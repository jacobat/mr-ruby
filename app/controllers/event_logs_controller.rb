class EventLogsController < ApplicationController
  def index
    @root_ids = $rep.root_ids
  end

  def show
    @events = $rep.events_for(params[:id])
  end
end
