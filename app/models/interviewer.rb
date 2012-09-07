class Interviewer < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :interview
end
