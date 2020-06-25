class Box < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates_uniqueness_of :label, :message => "must be unique"
  validates_numericality_of :label, :on => :create, :message => "is not a number"
end
