require 'test_helper'

class ActionVerbTest < ActiveSupport::TestCase
  def test_good_verb_in_the_middle
    assert ActionVerb.good_verb("We must Complete everything")
    assert !ActionVerb.bad_verb("We must Complete everything")
  end

  def test_good_verb_not_as_whole_word
    assert ActionVerb.good_verb("Mission completed")
    assert !ActionVerb.bad_verb("Mission completed")
  end

  def test_good_verb_case_insensitive
    assert ActionVerb.good_verb("COMPLETE")
    assert !ActionVerb.bad_verb("COMPLETE")
  end

  def test_good_verb
    assert ActionVerb.good_verb("Complete")
    assert !ActionVerb.bad_verb("Complete")
  end

  def test_bad_verb
    assert !ActionVerb.good_verb("Discuss")
    assert ActionVerb.bad_verb("Discuss")
  end

  def test_unknown_verb
    assert !ActionVerb.good_verb("Unknown")
    assert !ActionVerb.bad_verb("Unknown")
  end
end
