require 'test_helper'

class CustomizedSchemaTest < ActiveSupport::TestCase
  def test_schema_exists
    s = CustomizedSchema.find_all_customized_schemas(organizationalUnit__PUBLIC_ORGUNIT, CustomizedFieldType::EVENT)
    assert_equal 1, s.size
    assert_equal "PublicExtension", s[0].name

    s = CustomizedSchema.find_all_customized_schemas(organizationalUnit__COMPANIES_ORGUNIT, CustomizedFieldType::EVENT)
    assert_equal 1, s.size
    assert_equal "CompaniesExtension", s[0].name
  end

  def test_schema_exists_of_all_parent_org_units
    s = CustomizedSchema.find_all_customized_schemas(OrganizationalUnit.find_by_name("First Principles Management"), CustomizedFieldType::EVENT)
    assert_equal 2, s.size
    assert_equal "CompaniesExtension", s[1].name
    assert_equal "FpmExtension", s[0].name
  end
end
