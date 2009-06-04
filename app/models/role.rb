class Role < ActiveRecord::Base
  USER = 1 #Role.exists?(1) ? Role.find(1).id : nil
  ADMINISTRATOR = 2 #Role.exists?(2) ? Role.find(2).id : nil
  CUSTOMIZATOR = 3 #Role.exists?(3) ? Role.find(3).id : nil

  has_many :users
end
