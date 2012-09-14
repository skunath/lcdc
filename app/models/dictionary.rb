class Dictionary < ActiveRecord::Base
  # attr_accessible :title, :body

  set_table_name "dictionary"


  def self.convert_to_phonetic(utterance)
    first = utterance.gsub(/[^0-9a-z \']/i, ' ')
    first = first.downcase.split()


    mapping = []
    fail_mappings = []

    for word in first
      temp_mapping = []
      results = Dictionary.find(:all, :conditions => ["word = ?", word], :limit => 1)
      for item in results
        temp_mapping << item.pronunciation_slide
      end
      if temp_mapping.size == 0
        mapping << "(*)"
        real_num = 0
        real_num = 1 if Float(word) rescue real_num = 0
        fail_mappings << word if real_num == 0
      elsif temp_mapping.size == 1
        mapping << temp_mapping[0]
      else
        mapping << temp_mapping
      end
    end

    return [mapping, fail_mappings, first.size]
  end

end
