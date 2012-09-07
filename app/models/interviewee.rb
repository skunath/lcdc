class Interviewee < ActiveRecord::Base
  # attr_accessible :title, :body
  
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
