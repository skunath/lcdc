class CreateTranscriptionIndices < ActiveRecord::Migration
  def change
    create_table :transcription_indices do |t|

      t.timestamps
    end
  end
end
