require 'rubygems'
gem PLATFORM == 'java' ? 'rmagick4j' : 'rmagick'

# gruff
gem 'gruff'
require 'gruff'

class ReportsController < ApplicationController

  def uncompleted_actions_by_person
    g = Gruff::StackedBar.new()
    g.title = "Uncompleted Actions by Person"

    # labels
    labels = Hash.new()
    users = User.find_participated_primary_responsibles_users_of_meeting(current_meeting)
    i = 0
    users.each do |u|
      labels.store(i, u.name)
      i = i + 1
    end
    g.labels = labels

    datasets = [
      [:uncompleted, []],
      [:completed, []],
    ]
    users.each do |u|
      completed = 0
      uncompleted = 0
      Aktion.find_by_meeting(current_meeting).each do |a|
        if a.primary_responsible_id == u.id
          if a.completed
            completed = completed + 1
          else
            uncompleted = uncompleted + 1
          end
        end
      end
      datasets[0][1].insert(-1, uncompleted)#datasets[:ActionsToBeCompleted].insert(-1, uncompleted)
      datasets[1][1].insert(-1, completed)#datasets[:ActionsCompleted].insert(-1, completed)
    end

    datasets.each do |data|
      g.data(data[0], data[1])
    end

    send_data(g.to_blob,
      :disposition => 'inline',
      :type => 'image/png',
      :filename => "uncompleted_actions_by_person.png?" + rand(64000).to_s)
  end

  def timely_completion_of_actions_by_person
    g = Gruff::StackedBar.new()
    g.title = "Timely Completion of Actions by Person"

    # labels
    labels = Hash.new()
    users=User.find_participated_primary_responsibles_users_of_meeting(current_meeting)
    i = 0
    users.each do |u|
      labels.store(i, u.name)
      i = i + 1
    end
    g.labels = labels

    datasets = [
      [:overdue, []],
      [:ontime, []],
    ]
    users.each do |u|
      completed = 0
      uncompleted = 0
      Aktion.find_by_meeting(current_meeting).each do |a|
        if a.primary_responsible_id == u.id
          if a.completed_on_time
            completed = completed + 1
          else
            uncompleted = uncompleted + 1
          end
        end
      end
      datasets[0][1].insert(-1, uncompleted)#datasets[:ActionsToBeCompleted].insert(-1, uncompleted)
      datasets[1][1].insert(-1, completed)#datasets[:ActionsCompleted].insert(-1, completed)
    end

    datasets.each do |data|
      g.data(data[0], data[1])
    end

    send_data(g.to_blob,
      :disposition => 'inline',
      :type => 'image/png',
      :filename => "timely_completion_of_actions_by_person.png?" + rand(64000).to_s)
  end

  def number_of_actions_assigned_per_week
    g = Gruff::StackedBar.new()
    g.title = "Number of Actions assigned per Week"

    # labels
    labels = Hash.new()
    users = User.find(:all, :order => "id").collect{|d| [d.name]}
    i = 0
    users.each do |u|
      labels.store(i, u)
      i = i + 1
    end
    g.labels = labels

    # queries
    datasets = [
      [:ActionsOpen, []],
      [:ActionsClosed, []],
    ]
    User.find(:all, :order => "id").each do |u|
      closed = 0
      open = 0
      Aktion.find(:all, :conditions => ["primary_responsible_id = ?", u.id]).each do |i|
        if i.completed_on_time
          closed = closed + 1
        else
          open = open + 1
        end
      end
      datasets[0][1].insert(-1, open)
      datasets[1][1].insert(-1, closed)
    end

    datasets.each do |data|
      g.data(data[0], data[1])
    end

    send_data(g.to_blob,
      :disposition => 'inline',
      :type => 'image/png',
      :filename => "number_of_actions_assigned_per_week.png?" + rand(64000).to_s)
  end

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
