class Scaffold::PriorityRangesController < ApplicationController
  # GET /priority_ranges
  # GET /priority_ranges.xml
  def index
    @priority_ranges = PriorityRange.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @priority_ranges }
    end
  end

  # GET /priority_ranges/1
  # GET /priority_ranges/1.xml
  def show
    @priority_range = PriorityRange.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @priority_range }
    end
  end

  # GET /priority_ranges/new
  # GET /priority_ranges/new.xml
  def new
    @priority_range = PriorityRange.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @priority_range }
    end
  end

  # GET /priority_ranges/1/edit
  def edit
    @priority_range = PriorityRange.find(params[:id])
  end

  # POST /priority_ranges
  # POST /priority_ranges.xml
  def create
    @priority_range = PriorityRange.new(params[:priority_range])

    respond_to do |format|
      if @priority_range.save
        flash[:notice] = 'PriorityRange was successfully created.'
        format.html { redirect_to(@priority_range) }
        format.xml  { render :xml => @priority_range, :status => :created, :location => @priority_range }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @priority_range.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /priority_ranges/1
  # PUT /priority_ranges/1.xml
  def update
    @priority_range = PriorityRange.find(params[:id])

    respond_to do |format|
      if @priority_range.update_attributes(params[:priority_range])
        flash[:notice] = 'PriorityRange was successfully updated.'
        format.html { redirect_to(@priority_range) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @priority_range.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /priority_ranges/1
  # DELETE /priority_ranges/1.xml
  def destroy
    @priority_range = PriorityRange.find(params[:id])
    @priority_range.destroy

    respond_to do |format|
      format.html { redirect_to(priority_ranges_url) }
      format.xml  { head :ok }
    end
  end
end
