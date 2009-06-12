class OrganizationalUnit < ActiveRecord::Base

  PUBLIC_ORGUNIT = OrganizationalUnit.find_by_name("Public")
  COMPANIES_ORGUNIT = OrganizationalUnit.find_by_name("Companies")
  
  acts_as_nested_set
  before_save :correct_parent

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"

  has_and_belongs_to_many :users

  belongs_to :parent, :class_name=>"OrganizationalUnit"
  has_many :meetings
  belongs_to :responsible_user, :class_name=>"User"
  has_many :customized_schemas

  def current_user=(user)
    @current_user = user
  end
  
  def validate
    user = @current_user ? @current_user : current_user
    if user
      return if user.is_superuser?
      if (!user.organizational_units.empty?)
        errors.add_to_base "Parent can't be blank" if parent.nil? || :parent_id == 0
      end
    end
  end

  def correct_parent
    write_attribute :parent_id, 0 if parent.nil?
  end

  def self.find_all_organizational_units(organizational_units)
    return OrganizationalUnit.find(:all) if organizational_units == nil || organizational_units.empty?

    os = []
    organizational_units.each{ |organizational_unit|
      os = os | [organizational_unit.id] | organizational_unit.all_children
    }
    return os
  end
end
