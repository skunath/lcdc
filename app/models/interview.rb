class Interview < ActiveRecord::Base
  attr_accessible :interview_id, :interview_date, :source_class, :community_studied, :audio_recording_device, :audio_recording_format
  has_many :interviewees
  has_many :interviewers
  has_many :interview_files
  has_many :transcription_indices
  
   validates_uniqueness_of :interview_id
  
  def self.get_next_interview_id()
      max_id = self.count_by_sql("select max(interview_id) from interviews").to_i
      max_id += 1
      return max_id
  end
  
  def names
    output_names = []
    for interviewee in self.interviewees
      output_names << interviewee.pseudonym
    end
    return output_names.join(", ")
  end

  def sex
    output_sex = []
    for interviewee in self.interviewees
      output_sex << interviewee.sex
    end
    return output_sex.join(", ")
  end

  def ethnicity
    output_ethnicities = []
    for interviewee in self.interviewees
      output_ethnicities << interviewee.ethnicity_label
    end
    return output_ethnicities.join(", ")
  end

  def age
    output_ages = []
    for interviewee in self.interviewees
      if !interviewee.age.nil?
        output_ages << interviewee.age
      else
        output_ages << "Unknown"
      end
    end
    return output_ages.join(", ")
  end


  
end
