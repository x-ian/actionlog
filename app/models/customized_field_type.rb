class CustomizedFieldType < ActiveRecord::Base
  validates_presence_of :field_type
  validates_uniqueness_of :field_type

  has_many :customized_schemas

  EVENT = CustomizedFieldType.exists?(1) ? CustomizedFieldType.find(1).id : nil
  AKTION = CustomizedFieldType.exists?(2) ? CustomizedFieldType.find(2).id : nil
end
