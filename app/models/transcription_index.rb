class TranscriptionIndex < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :interview
  belongs_to :interview_file
end
