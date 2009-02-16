module ActionLogInplaceEditHelper

  def create_user_select_tag_options(object, list, include_blank)
    tag = ""
    tag = "<option></option>" if include_blank
    list.each do |i|
      if object != nil && object.name == i.name
        tag += "<option selected='selected' value=#{object.id}>" + i.name + "</option>"
      else
        tag += "<option value='#{i.id}'>" + i.name + "</option>"
      end

    end
    return tag
  end

end
