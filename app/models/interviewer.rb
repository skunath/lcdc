class Interviewer < ActiveRecord::Base
  attr_accessible :name, :sex, :ethnicity, :age
  validates_presence_of :name
  belongs_to :interview
end
