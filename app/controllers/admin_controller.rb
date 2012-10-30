class AdminController < ApplicationController
  layout "admin"
  require 'ftools'
  require 'shellwords'
  
  def index
    @interviews = Interview.find(:all, :order => "interview_id")
  end

  def view_interview
    @interview = Interview.find(params[:id])
  end
  
  def disable_interview
    @interview = Interview.find(params[:id])
    @interview.visible = 0
    @interview.save
    redirect_to :action => "index"
  end

  def enable_interview
    @interview = Interview.find(params[:id])
    @interview.visible = 1
    @interview.save
    redirect_to :action => "index"
  end

  def disable_file
    @file = InterviewFile.find(params[:id])
    @file.visible = 0
    @file.save
    redirect_to :action => "view_interview", :id => @file.interview_id
  end

  def enable_file
    @file = InterviewFile.find(params[:id])
    @file.visible = 1
    @file.save
    redirect_to :action => "view_interview", :id => @file.interview_id
  end

  def associate_file
    @interview = Interview.find(params[:id])
    
  end

  def move_file
    @interview = Interview.find(params[:id])
    
    # code to move files
    begin
      move_location = Lcdc::Application.config.LCDC_File_Location + ("%03d" % @interview.interview_id.to_s) + "/" + File.basename(params[:filename])
      FileUtils.mv(Shellwords.escape(params[:filename]), Shellwords.escape(move_location))
      @ifile = @interview.interview_files.new
      @ifile.file_name = File.basename(params[:filename])
      @ifile.save
      
      redirect_to :action => "view_interview", :id => @interview.id
    rescue
      redirect_to :action => "associate_file", :id => @interview.id
    end
  
  end
  
  
   def transcript_view
    if !params[:time_start].nil?
      @skip_to = params[:time_start]
    end
    
    
    # get the xml
    file = InterviewFile.find(params[:id])
  
    @bad_mappings = []
    @word_count = 0
    @word_count_wrong = 0


        doc = Nokogiri::XML(open(Lcdc::Application.config.LCDC_File_Location + ("%03d" % file.interview.interview_id.to_s) + "/" + file.file_name ))

        @transcriber = ""

        doc.xpath('//Trans').each do |node|
                @transcriber = node.attributes["scribe"]
        end


        @speakers = {}
        doc.xpath('//Speaker').each do |node|
                @speakers[node.attributes["id"].value.strip] = node.attributes["name"].value.strip
        end

        @turns = []
        doc.xpath('//Turn').each do |node|
                temp = []
                if node.attributes.has_key?("speaker")
      temp << node.attributes["speaker"].value.strip 
                else
      temp << " "
    end
    temp << node.attributes["startTime"].value.strip
                temp << node.text
                mappings = Dictionary.convert_to_phonetic(node.text)
    temp << mappings[0]
    @bad_mappings.concat(mappings[1])
    @word_count += mappings[2]
    @word_count_wrong += mappings[1].size
    @turns << temp
        end
  end


  def new_interview
    @interview = Interview.new
    @next_id = Interview.get_next_interview_id
    if request.post?
      @interview = Interview.new(params[:interview])
      if @interview.save
        redirect_to :action => "new_interview_2", :id => @interview.id
      end
    end
  end

  def new_interview_2
    @interview = Interview.find(params[:id])
    @interviewee = @interview.interviewees.new()
    if request.post?
      @interviewee = Interviewee.new(params[:interviewee])
      @interviewee.interview_id = @interview.id
      if @interviewee.save
        @interviewee = @interview.interviewees.new()
        @display_link_next = true
      end
    end
  end


 def new_interview_3
    @interview = Interview.find(params[:id])
    @interviewer = @interview.interviewers.new()
    if request.post?
      @interviewer = Interviewer.new(params[:interviewer])
      @interviewer.interview_id = @interview.id
      if @interviewer.save
        @interviewer = @interview.interviewers.new()
        @display_link_next = true
      end
    end
  end


end
