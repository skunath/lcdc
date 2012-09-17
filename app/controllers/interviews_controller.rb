class InterviewsController < ApplicationController
  def index
    @interviews = Interview.find(:all, :order => "interview_id")
  end

  def view_interview
    @interview = Interview.find(params[:id])
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

  def transcript_search
    if !params[:search].nil? 
      @transcript_results = TranscriptionIndex.find(:all, :conditions => ["lower(transcription) like ?", "%" + params[:search].downcase().strip() + "%"])
    else
      redirect_to :action => "index"
    end
  end


end
