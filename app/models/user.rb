class User < ActiveRecord::Base
  before_save :deal_with_account

  validates_presence_of     :pw
  validates_length_of       :pw,    :within => 6..40

  # stolen from restful_authentication
  include Authentication
  validates_presence_of     :login
  validates_length_of       :login,    :within => 2..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  #validates_presence_of     :email
  #validates_length_of       :email,    :within => 6..100 #r@a.wk
  #validates_uniqueness_of   :email
  #validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  has_many :events
  has_many :requested_bys, :class_name=>"Aktion"
  has_many :primary_responsibles, :class_name=>"Aktion"
  has_many :secondary_responsibles, :class_name=>"Aktion"

  has_many :responsible_users, :class_name=>"User"

  belongs_to :account, :dependent => :destroy

  belongs_to :role

  #belongs_to :meeting

  has_and_belongs_to_many :organizational_units
  has_and_belongs_to_many :meetings

  def deal_with_account
    write_attribute :login, (self[:login] ? self[:login].downcase : nil)
    write_attribute :email, (self[:email] ? self[:email].downcase : nil)

    account = Account.new if self.account.nil?
    account = self.account unless self.account.nil?
    account.name = self[:name]
    account.email = self[:email]
    account.password = self[:pw]
    account.password_confirmation = self[:pw]
    account.login = self[:login]
    account.save
    self.account = account
  end

  def is_user?
    return false if self.role_id == nil
    (self.role_id == Role::USER) ? true : false
  end

  def is_administrator?
    return false if self.role_id == nil
    (self.role_id == Role::ADMINISTRATOR) ? true : false
  end

  def is_customizator?
    return false if self.role_id == nil
    (self.role_id == Role::CUSTOMIZATOR) ? true : false
  end

  def self.find_participated_primary_responsibles_users_of_meeting(meeting)
#    User.find(:all, :order => "id").collect{|d| [d.name]}
    j = "LEFT JOIN aktions ON aktions.primary_responsible_id = users.id "
    j += "LEFT JOIN events ON events.id = aktions.event_id "
    j += "LEFT JOIN event_areas on event_areas.id = events.event_area_id "
    j += "LEFT JOIN meetings ON meetings.id = event_areas.meeting_id"
    User.find(:all, :select => "DISTINCT(users.id), users.*", :conditions => [ "meetings.id = ?", meeting.id], :joins => j, :order => "name")
  end

  def first_name
    (name.split(" "))[0]
  end

  def initials
    initials = ""
    parts = name.split(" ")
    parts.collect { |item| initials += item[0..0].upcase }
    initials
  end
end
