class CustomizedFieldType < ActiveRecord::Base
  validates_presence_of :field_type
  validates_uniqueness_of :field_type

  has_many :customized_schemas

  EVENT = 1 #CustomizedFieldType.exists?(1) ? CustomizedFieldType.find(1).id : nil
  AKTION = 2 #CustomizedFieldType.exists?(2) ? CustomizedFieldType.find(2).id : nil
end
