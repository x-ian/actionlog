class Role < ActiveRecord::Base
  USER = Role.find(1).id
  ADMINISTRATOR = Role.find(2).id
  CUSTOMIZATOR = Role.find(3).id

  has_many :users
end
