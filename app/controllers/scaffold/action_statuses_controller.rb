class Scaffold::ActionStatusesController < ApplicationController
  # GET /action_statuses
  # GET /action_statuses.xml
  def index
    @action_statuses = ActionStatus.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @action_statuses }
    end
  end

  # GET /action_statuses/1
  # GET /action_statuses/1.xml
  def show
    @action_status = ActionStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @action_status }
    end
  end

  # GET /action_statuses/new
  # GET /action_statuses/new.xml
  def new
    @action_status = ActionStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @action_status }
    end
  end

  # GET /action_statuses/1/edit
  def edit
    @action_status = ActionStatus.find(params[:id])
  end

  # POST /action_statuses
  # POST /action_statuses.xml
  def create
    @action_status = ActionStatus.new(params[:action_status])

    respond_to do |format|
      if @action_status.save
        flash[:notice] = 'ActionStatus was successfully created.'
        format.html { redirect_to(@action_status) }
        format.xml  { render :xml => @action_status, :status => :created, :location => @action_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @action_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /action_statuses/1
  # PUT /action_statuses/1.xml
  def update
    @action_status = ActionStatus.find(params[:id])

    respond_to do |format|
      if @action_status.update_attributes(params[:action_status])
        flash[:notice] = 'ActionStatus was successfully updated.'
        format.html { redirect_to(@action_status) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @action_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /action_statuses/1
  # DELETE /action_statuses/1.xml
  def destroy
    @action_status = ActionStatus.find(params[:id])
    @action_status.destroy

    respond_to do |format|
      format.html { redirect_to(action_statuses_url) }
      format.xml  { head :ok }
    end
  end
end
