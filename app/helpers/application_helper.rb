# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def tree_select(categories, model, name, selected=nil, onchange="", level=0, init=true)
    html = ""
    # The "Root" option is added
    # so the user can choose a parent_id of 0
    if init
      # Add "Root" to the options
      html << "<select name=\"#{model}[#{name}]\" id=\"#{model}_#{name}\" onchange=\"#{onchange}\">\n"
      html << "\t<option value=\"0\""
      html << " selected=\"selected\"" if selected != nil && selected.parent_id == nil
      html << ">Root</option>\n"
    end

    if categories.length > 0
      level += 1 # keep position
      categories.collect do |cat|
        indent = "&nbsp;" * level * 2
        #html << "\t<option value=\"#{cat.id}\" style=\"padding-left:#{level * 10}px\""
        html << "\t<option value=\"#{cat.id}\""
        html << ' selected="selected"' if selected != nil && cat.id == selected.id
        html << ">#{indent}#{cat.name}</option>\n"
        html << tree_select(cat.children, model, name, selected, onchange, level, false)
      end
    end
    html << "</select>\n" if init
    return html
  end

  def current_user
    return current_account.user
  end

  def current_meeting
    logger.debug "CURRENT MEETING: #{session[:current_meeting]}"
    return session[:current_meeting] unless session[:current_meeting].blank?
    #session[:current_meeting] = current_user.meetings.first unless current_user.meetings.size < 1
  end

  def create_collection_select_tag_options(object, list, include_blank, value_method, text_method)
    tag = ""
    tag = "<option></option>" if include_blank
    list.each do |i|
      if object != nil && object.send(value_method) == i.send(value_method)
        tag += "<option selected='selected' value=#{object.send(value_method)}>" + i.send(text_method) + "</option>"
      else
        tag += "<option value='#{i.send(value_method)}'>" + i.send(text_method) + "</option>"
      end

    end
    return tag
  end

end
