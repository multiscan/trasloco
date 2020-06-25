class Room < ApplicationRecord
  belongs_to :user
  has_many :boxes, :class_name => "Box", :foreign_key => "room_id", :dependent => :delete_all
  validates_uniqueness_of :label, :message => "must be unique"
end
