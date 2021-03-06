class Scaffold::AktionsController < ApplicationController
  # GET /aktions
  # GET /aktions.xml
  def index
    @aktions = Aktion.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aktions }
    end
  end

  # GET /aktions/1
  # GET /aktions/1.xml
  def show
    @aktion = Aktion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aktion }
    end
  end

  # GET /aktions/new
  # GET /aktions/new.xml
  def new
    @aktion = Aktion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aktion }
    end
  end

  # GET /aktions/1/edit
  def edit
    @aktion = Aktion.find(params[:id])
  end

  # POST /aktions
  # POST /aktions.xml
  def create
    @aktion = Aktion.new(params[:aktion])

    respond_to do |format|
      if @aktion.save
        flash[:notice] = 'Aktion was successfully created.'
        format.html { redirect_to(@aktion) }
        format.xml  { render :xml => @aktion, :status => :created, :location => @aktion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aktion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aktions/1
  # PUT /aktions/1.xml
  def update
    @aktion = Aktion.find(params[:id])

    respond_to do |format|
      if @aktion.update_attributes(params[:aktion])
        flash[:notice] = 'Aktion was successfully updated.'
        format.html { redirect_to(@aktion) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aktion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aktions/1
  # DELETE /aktions/1.xml
  def destroy
    @aktion = Aktion.find(params[:id])
    @aktion.destroy

    respond_to do |format|
      format.html { redirect_to(aktions_url) }
      format.xml  { head :ok }
    end
  end
end
