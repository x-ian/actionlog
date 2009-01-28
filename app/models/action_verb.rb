class ActionVerb < ActiveRecord::Base
  validates_presence_of :verb
  validates_uniqueness_of :verb

  def self.good_verbs
    return ActionVerb.find_all_by_disliked(false)
  end

  def self.bad_verbs
    return ActionVerb.find_all_by_disliked(true)
  end

  def self.good_verb(verb)
    return part_of(good_verbs, verb)
  end

  def self.bad_verb(verb)
    return part_of(bad_verbs, verb)
  end

  def self.part_of(verbs, phrase)
    d = verbs.detect { |e| phrase.downcase.index(e.verb.downcase) != nil && phrase.downcase.index(e.verb.downcase) > -1 }
    return d != nil
  end

end
