#file to manage the import of ediscovery stuff from pre-defined templates

require 'rubygems'
require 'mysql2'
require 'active_record'
require 'nokogiri'


# need to change and run the indexer on the live server
ActiveRecord::Base.establish_connection(  
:adapter => "mysql2",  
:host => "localhost",  
:username => "root",
:database => "lcdc"  
)  
  

class Interview < ActiveRecord::Base  
  has_many :transcription_indices
  has_many :interview_files
end
  
class InterviewFile < ActiveRecord::Base  
  has_many :transcription_indices
  belongs_to :interview
end

class TranscriptionIndex < ActiveRecord::Base  
  belongs_to :interview
  belongs_to :interview_file
end


$base_dir = "/projects/lcdc/temp_data/"

# processing code

def process_transcription(file_record)
  # open and parse
  doc = nil
  begin
    doc = Nokogiri::XML(open($base_dir + ("%03d" % file_record.interview.interview_id.to_s) + "/" + file_record.file_name ))
  rescue
    puts "Doc opening failed..."
  end
  
  # get the transcriber stuff
  @transcriber = ""
  doc.xpath('//Trans').each do |node|
          @transcriber = node.attributes["scribe"]
  end
  
    

  
  # get speaker labels  
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
      temp << node.text.strip
      @turns << temp
  end

  # now load into database...

  for i in @turns
    new_index_item = TranscriptionIndex.new()
    new_index_item.interview_id = file_record.interview.id
    new_index_item.speaker = i[0].strip()
    new_index_item.time = Float(i[1].strip)
    new_index_item.transcription = i[2]
    new_index_item.interview_file_id = file_record.id
    new_index_item.save
  end


  puts "Processed record..."


end


# first, delete anything in the index....

ActiveRecord::Base.connection.execute("delete from transcription_indices")


# spin through interviews
interviews = Interview.find(:all, :conditions => "visible = 1")

for i in interviews
  # check to see if it has transcription files...
  for j in i.interview_files.find(:all, :conditions => "visible = 1 and file_name like '%.trs%'")
    # check to see if file exists and can be opened...
    begin
      open($base_dir + ("%03d" % j.interview.interview_id.to_s) + "/" + j.file_name )
      process_transcription(j)
      
    rescue
      #puts "! " * 10 
      #puts "Couldn't open: " + j.file_name
      #puts "$ " * 10
    end
    
  end
end



