class CreateInterviewees < ActiveRecord::Migration
  def change
    create_table :interviewees do |t|

      t.timestamps
    end
  end
end
