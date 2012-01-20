class Dilemma < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  has_many :reasons
  accepts_nested_attributes_for :reasons, allow_destroy: true
  # attr_accessible :name, :reasons_attributes, :user
end

