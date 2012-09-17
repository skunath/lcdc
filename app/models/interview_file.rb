class InterviewFile < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :interview
  has_many :transcription_indices
end
