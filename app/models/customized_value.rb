class CustomizedValue < ActiveRecord::Base
  belongs_to :customized_schema
  belongs_to :aktion
  belongs_to :event
end
