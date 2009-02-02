class OrganizationalUnit < ActiveRecord::Base
  acts_as_nested_set

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"

  has_and_belongs_to_many :users
  belongs_to :parent, :class_name=>"OrganizationalUnit"

  has_many :meetings
end
