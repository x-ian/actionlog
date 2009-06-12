class CustomizedSchema < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "organizational_unit_id"
  validates_presence_of :organizational_unit_id
  validates_presence_of :customized_field_type_id

  belongs_to :organizational_unit
  belongs_to :customized_field_type
  has_many :customized_values

  def self.find_all_customized_schemas(org_unit, field_type_id)
    s = []
    org_unit.self_and_ancestors.reverse_each do |item|
      unless item.customized_schemas.empty?
        s = s | CustomizedSchema.find(:all, :conditions => [ "customized_field_type_id = ? AND organizational_unit_id = ?", field_type_id, item.id ])
      end
    end
    return s
  end

end
