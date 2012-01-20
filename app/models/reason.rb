class Reason < ActiveRecord::Base
  self.inheritance_column = :sti_type

  attr_accessible :type, :text, :dilemma

  validates_presence_of :text, :type
  validates_inclusion_of :type, in: [:pro, :con]

  belongs_to :dilemma
end

