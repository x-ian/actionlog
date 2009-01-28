require "parsedate.rb"
include ParseDate

namespace :utils do
  desc "Create default users"
  task(:create_default_users => :environment ) do
    create_superuser
    create_administrator
    create_neumann
    create_franklin
  end

  def create_franklin
    return unless User.find_by_name("Franklin") == nil
    u = User.new(:name=>"Franklin")
    u.login="franklin"
    u.pw = "franklin"
    u.role_id=1
    u.save
  end

  def create_neumann
    return unless User.find_by_name("Neumann") == nil
    u = User.new(:name=>"Neumann")
    u.login="neumann"
    u.pw = "neumann"
    u.role_id=1
    u.save
  end

  def create_superuser
    return unless User.find_by_name("Superuser") == nil
    u = User.new(:name=>"Superuser")
    u.login="superuser"
    u.pw = "superuser"
    u.role_id=3
    u.save
  end

  def create_administrator
    return unless User.find_by_name("Administrator") == nil
    u = User.new(:name=>"Administrator")
    u.login="administrator"
    u.pw = "administrator"
    u.role_id=2
    u.save
  end

  desc "Import"
  task(:import_actionlog_dummy_data_set => :environment ) do

    file = "lib/tasks/ActionLog Dummy Data Set.csv"
    #file = "/home/webuser/actionlog/lib/tasks/ActionLog Dummy Data Set.csv"
    import_users(file)
    import_events(file)
    import_actions(file)

    create_superuser
    create_administrator
    create_neumann
    create_franklin
  end

  def import_users(file)
    User.find(:all).each{|u|u.destroy()}
    File.open(file, "r") do |aFile|
      aFile.each_line do |substr|
        values = substr.split(";")
        u = User.new(:name=>values[16])
        u.login=u.name.gsub(/ /, "").strip
        u.pw = u.name.gsub(/ /, "").strip.downcase
        u.role_id=1
        u.save
        u = User.new(:name=>values[9])
        u.login=u.name.gsub(/ /, "").strip
        u.pw = u.name.gsub(/ /, "").strip.downcase
        u.role_id=1
        u.save
        u = User.new(:name=>values[8])
        u.login=u.name.gsub(/ /, "").strip
        u.pw = u.name.gsub(/ /, "").strip.downcase
        u.role_id=1
        u.save
      end
    end
  end

  def conv_excel_date (xls_date)
    xls_date = xls_date.sub(/Mrz/, "Mar")
    xls_date = xls_date.sub(/Mai/, "May")
    xls_date = xls_date.sub(/Okt/, "Oct")
    xls_date = xls_date.sub(/Dez/, "Dec")
    p = parsedate(xls_date, true)
    s = p[0].to_s+"-"+p[1].to_s+"-"+p[2].to_s if p != nil
    return s
  end

  def import_events(file)
    Event.find(:all).each{|a|a.destroy}
    File.open(file, "r") do |aFile|
      aFile.each_line do |substr|
        values = substr.split(";")
        e = Event.new
        e.event_area_id = 2
        e.log_date = conv_excel_date(values[4])
        e.event_type = EventType.find_by_name(values[5])
        e.event_type = EventType.find_by_name("Issue") if e.event_type == nil
        e.name = values[6]
        e.save
      end
    end
  end

  def import_actions(file)
    Aktion.find(:all).each{|a|a.destroy}
    File.open(file, "r") do |aFile|
      aFile.each_line do |substr|
        values = substr.split(";")
        puts substr
        a = Aktion.new
        a.event = Event.find_by_name(values[6])
        a.event = Event.find(:all).first if a.event == nil
        a.action_required = values[7]
        a.primary_responsible = User.find_by_name(values[8])
        a.secondary_responsible = User.find_by_name(values[9])
        a.review_date = conv_excel_date(values[11])
        a.target_date = conv_excel_date(values[12])
        a.new_target_date = conv_excel_date(values[13])

        a.actual_completion_date = conv_excel_date(values[15])
        a.requested_by = User.find_by_name(values[16])
        a.closeout_comment = values[17]

        #        a.completed = values[14] == "Y" ? true : false
        a.save
      end
    end


  end




  desc "Iterates through models in the app and does something with each of them"
  task :do_something_with_models => :environment do
    require 'find'
    models=[]
    path="#{RAILS_ROOT}/app/models"
    Find.find(path) do |p|
      if FileTest.directory?(p) and p!=path
        Find.prune # don't recurse into directories
        next
      end
      if p =~ /.rb$/
        puts p
        models << File.basename(p,".*").classify
      end
    end
    models.each do |m|
      puts m
      # Insert code here to do something useful with each model.
      # You can retrieve a collection from the model like this
      # eval("collection=#{m}.find(:all)") …
    end
  end

end
