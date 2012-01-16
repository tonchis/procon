class List < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  has_many :items

  def pros
    items.where(type: :pro).all
  end

  def cons
    items.where(type: :con).all
  end
end

