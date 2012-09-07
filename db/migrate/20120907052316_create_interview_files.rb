class CreateInterviewFiles < ActiveRecord::Migration
  def change
    create_table :interview_files do |t|

      t.timestamps
    end
  end
end
