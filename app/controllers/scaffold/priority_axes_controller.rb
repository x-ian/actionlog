class Scaffold::PriorityAxesController < ApplicationController
  # GET /priority_axes
  # GET /priority_axes.xml
  def index
    @priority_axes = PriorityAxis.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @priority_axes }
    end
  end

  # GET /priority_axes/1
  # GET /priority_axes/1.xml
  def show
    @priority_axis = PriorityAxis.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @priority_axis }
    end
  end

  # GET /priority_axes/new
  # GET /priority_axes/new.xml
  def new
    @priority_axis = PriorityAxis.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @priority_axis }
    end
  end

  # GET /priority_axes/1/edit
  def edit
    @priority_axis = PriorityAxis.find(params[:id])
  end

  # POST /priority_axes
  # POST /priority_axes.xml
  def create
    @priority_axis = PriorityAxis.new(params[:priority_axis])

    respond_to do |format|
      if @priority_axis.save
        flash[:notice] = 'PriorityAxis was successfully created.'
        format.html { redirect_to(@priority_axis) }
        format.xml  { render :xml => @priority_axis, :status => :created, :location => @priority_axis }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @priority_axis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /priority_axes/1
  # PUT /priority_axes/1.xml
  def update
    @priority_axis = PriorityAxis.find(params[:id])

    respond_to do |format|
      if @priority_axis.update_attributes(params[:priority_axis])
        flash[:notice] = 'PriorityAxis was successfully updated.'
        format.html { redirect_to(@priority_axis) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @priority_axis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /priority_axes/1
  # DELETE /priority_axes/1.xml
  def destroy
    @priority_axis = PriorityAxis.find(params[:id])
    @priority_axis.destroy

    respond_to do |format|
      format.html { redirect_to(priority_axes_url) }
      format.xml  { head :ok }
    end
  end
end
