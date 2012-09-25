class Interviewee < ActiveRecord::Base
  attr_accessible :pseudonym, :age, :sex, :ethnicity, :community, :occupation, :education, :childhood_residence, :current_residence
  validates_presence_of :pseudonym, :age, :sex, :ethnicity, :community
  belongs_to :interview
  
  def ethnicity_label
    label = ""
    case self.ethnicity
    when "w"
      label = "White"
    when "a"
      label = "African American"
    when "s"
      label = "Asian"
    when "l"
      label = "Latino/a"
    else
      label = "Unknown"
    end
    return label
  end
  
  
end
