class Role < ActiveRecord::Base
  USER = Role.exists?(1) ? Role.find(1).id : nil
  ADMINISTRATOR = Role.exists?(2) ? Role.find(2).id : nil
  CUSTOMIZATOR = Role.exists?(3) ? Role.find(3).id : nil

  has_many :users
end
