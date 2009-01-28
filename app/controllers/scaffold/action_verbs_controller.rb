class Scaffold::ActionVerbsController < ApplicationController
  # GET /action_verbs
  # GET /action_verbs.xml
  def index
    @action_verbs = ActionVerb.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @action_verbs }
    end
  end

  # GET /action_verbs/1
  # GET /action_verbs/1.xml
  def show
    @action_verb = ActionVerb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @action_verb }
    end
  end

  # GET /action_verbs/new
  # GET /action_verbs/new.xml
  def new
    @action_verb = ActionVerb.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @action_verb }
    end
  end

  # GET /action_verbs/1/edit
  def edit
    @action_verb = ActionVerb.find(params[:id])
  end

  # POST /action_verbs
  # POST /action_verbs.xml
  def create
    @action_verb = ActionVerb.new(params[:action_verb])

    respond_to do |format|
      if @action_verb.save
        flash[:notice] = 'ActionVerb was successfully created.'
        format.html { redirect_to(@action_verb) }
        format.xml  { render :xml => @action_verb, :status => :created, :location => @action_verb }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @action_verb.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /action_verbs/1
  # PUT /action_verbs/1.xml
  def update
    @action_verb = ActionVerb.find(params[:id])

    respond_to do |format|
      if @action_verb.update_attributes(params[:action_verb])
        flash[:notice] = 'ActionVerb was successfully updated.'
        format.html { redirect_to(@action_verb) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @action_verb.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /action_verbs/1
  # DELETE /action_verbs/1.xml
  def destroy
    @action_verb = ActionVerb.find(params[:id])
    @action_verb.destroy

    respond_to do |format|
      format.html { redirect_to(action_verbs_url) }
      format.xml  { head :ok }
    end
  end
end
