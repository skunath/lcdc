class AdminController < ApplicationController
  layout "admin"

  def index
    @interviews = Interview.find(:all, :order => "interview_id")
  end

end
