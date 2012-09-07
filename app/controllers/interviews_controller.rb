class InterviewsController < ApplicationController
  def index
    @interviews = Interview.find(:all, :order => "interview_id")
  end

  def view_interview
    @interview = Interview.find(params[:id])
  end

end
