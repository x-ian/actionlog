class OrganizationalUnit < ActiveRecord::Base
  acts_as_nested_set

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"

  #belongs_to :parent, :class_name => "OrganizationalUnit"
  #has_many :parents, :class_name => "OrganizationalUnit"
  #has_many :meetings
end
