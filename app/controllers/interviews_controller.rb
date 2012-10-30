class InterviewsController < ApplicationController
  respond_to :html, :xml, :json
  
  
  def index
    @interviews = Interview.find(:all, :conditions => "visible = 1", :order => "interview_id")
    @ethnicities = Ethnicity.find(:all, :order => "ethnicity")

    
  end

  def update_interviews
    sql_age, sql_ethnicity, sql_sex = "", "", ""    
    all_sql = []


    if params[:lower_age] != "" && params[:upper_age] != ""
      if params[:lower_age].to_i <=  params[:upper_age].to_i
        sql_age = " interviewees.age >= " + params[:lower_age].strip + " and interviewees.age <= " + params[:upper_age]
        all_sql << sql_age
      end
    end

    if params[:ethnicity] != "" && !params[:ethnicity].nil? 
      ethnicity = params[:ethnicity].to_a
      ethnicity.delete("")
      
      if ethnicity.size > 0
        sql_ethnicity = ethnicity.map{|item| " interviewees.ethnicity = '" + item.to_s.strip + "' "}.join(" or ")
        sql_ethnicity = "( " + sql_ethnicity + " )"
        all_sql << sql_ethnicity
      end
    end
    
     if params[:sex] != "" && !params[:sex].nil?
      # need to check to see if there was anything in the list
      sex = params[:sex].to_a
      sex.delete("")
      
      if sex.size > 0
        sql_sex = sex.map{|item| " interviewees.sex = '" + item.to_s.strip + "' "}.join(" or ")
        sql_sex = "( " + sql_sex + " )"
        all_sql << sql_sex 
     end
    end
    end_sql = ""
    end_sql = " and "  +  all_sql.join(" and ") if all_sql.size > 0
    
    
    @interviews = Interview.find_by_sql("select i.* from interviews i left outer join interviewees on i.id = interviewees.interview_id  where i.interview_id is not null and i.visible = 1 " + end_sql + "  group by i.interview_id order by i.interview_id")
    
    respond_with do |format|
      format.js
    end
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
