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
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  #validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  has_many :events
  has_many :requested_bys, :class_name=>"Aktion"
  has_many :primary_responsibles, :class_name=>"Aktion"
  has_many :secondary_responsibles, :class_name=>"Aktion"

  has_many :responsible_users, :class_name=>"User"

  belongs_to :account, :dependent => :destroy

  belongs_to :role

  has_and_belongs_to_many :organizational_units
  has_and_belongs_to_many :meetings

  def deal_with_account
    write_attribute :login, (self[:login] ? self[:login].downcase : nil)
    write_attribute :email, (self[:email] ? self[:email].downcase : nil)

    a = self.account unless self.account.nil?
    if !self.public_user
      a = Account.new if self.account.nil?
      a.state=:active
      self.public_user=false
    end
    a.name = self[:name]
    a.email = self[:email]
    a.password = self[:pw]
    a.pw = self[:pw]
    a.password_confirmation = self[:pw]
    a.login = self[:login]
    a.save
    self.account = a
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

  def is_superuser?
    return self.login == "superuser"
  end

  def self.find_participated_primary_responsibles_users_of_meeting(meeting)
    #    User.find(:all, :order => "id").collect{|d| [d.name]}
    j = "LEFT JOIN aktions ON aktions.primary_responsible_id = users.id "
    j += "LEFT JOIN events ON events.id = aktions.event_id "
    j += "LEFT JOIN event_areas on event_areas.id = events.event_area_id "
    j += "LEFT JOIN meetings ON meetings.id = event_areas.meeting_id"
    User.find(:all, :select => "DISTINCT(users.id), users.*", :conditions => [ "meetings.id = ?", meeting.id], :joins => j, :order => "name")
  end

  def self.find_all_users_of_organizational_unit(organizational_unit)
    return User.find(:all) if organizational_unit == nil

    return self.find_all_users_of_organizational_units([organizational_unit])
  end

  def self.find_all_users_of_organizational_units(organizational_units)
    return User.find(:all) if organizational_units == nil || organizational_units.empty?

    a = []
    organizational_units.each{ |organizational_unit|
      a = a | [organizational_unit.id] | organizational_unit.all_children
    }
    return User.find(:all, :joins => :organizational_units, :conditions => [ "organizational_units_users.organizational_unit_id in (?)", a])
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

  def initialize_default_public_user_data(account)
    # account stuff
    self.name = account.login
    self.email = account.email
    self.login = account.login
    self.pw = account.pw
    self.role_id = Role::USER
    self.public_user = true
    self.account = account

    # org unit
    o = OrganizationalUnit.new
    o.name = self.login
    #o.parent_id = 0
    o.description = "Default Organizational Unit for user #{self.login}"
    o.responsible_user = self
    o.users << self
    o.save

    # meeting
    m = Meeting.new
    m.name = "My Meeting"
    m.description =" Default Meeting for user #{self.login}"
    m.organizational_unit_id = o.id
    m.responsible_user_id = self.id
    m.users << self
    m.save

    # event area
    ea = EventArea.new
    ea.name = "Default Event Area"
    ea.description ="Default Event area for user #{self.login}"
    ea.meeting_id = m.id
    ea.save
    
  end
end
