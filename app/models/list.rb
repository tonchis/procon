class List < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  has_many :items
  accepts_nested_attributes_for :items, allow_destroy: true
  attr_accessible :name, :items_attributes
end

