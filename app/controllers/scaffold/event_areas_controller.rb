class Scaffold::EventAreasController < ApplicationController
  # GET /event_areas
  # GET /event_areas.xml
  def index
    @event_areas = EventArea.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event_areas }
    end
  end

  # GET /event_areas/1
  # GET /event_areas/1.xml
  def show
    @event_area = EventArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event_area }
    end
  end

  # GET /event_areas/new
  # GET /event_areas/new.xml
  def new
    @event_area = EventArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event_area }
    end
  end

  # GET /event_areas/1/edit
  def edit
    @event_area = EventArea.find(params[:id])
  end

  # POST /event_areas
  # POST /event_areas.xml
  def create
    @event_area = EventArea.new(params[:event_area])

    respond_to do |format|
      if @event_area.save
        flash[:notice] = 'EventArea was successfully created.'
        format.html { redirect_to(@event_area) }
        format.xml  { render :xml => @event_area, :status => :created, :location => @event_area }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_areas/1
  # PUT /event_areas/1.xml
  def update
    @event_area = EventArea.find(params[:id])

    respond_to do |format|
      if @event_area.update_attributes(params[:event_area])
        flash[:notice] = 'EventArea was successfully updated.'
        format.html { redirect_to(@event_area) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_areas/1
  # DELETE /event_areas/1.xml
  def destroy
    @event_area = EventArea.find(params[:id])
    @event_area.destroy

    respond_to do |format|
      format.html { redirect_to(event_areas_url) }
      format.xml  { head :ok }
    end
  end
end
