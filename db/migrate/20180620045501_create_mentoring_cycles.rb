class CreateMentoringCycles < ActiveRecord::Migration[5.1]
  def change
    create_table :mentoring_cycles do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end

    add_reference :mentorings, :mentoring_cycle, index: true
    change_column_null :mentorings, :mentoring_cycle_id, false
  end
end
