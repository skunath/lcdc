class Interview < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :interviewees
  has_many :interviewers
  has_many :interview_files
  
  
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
