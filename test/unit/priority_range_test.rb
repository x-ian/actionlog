require 'test_helper'

class PriorityRangeTest < ActiveSupport::TestCase
  def test_to_label
    assert_equal "MyString", priority_ranges(:one).to_label
  end
end
