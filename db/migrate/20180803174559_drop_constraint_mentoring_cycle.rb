class DropConstraintMentoringCycle < ActiveRecord::Migration[5.1]
  def change
    change_column_null :mentoring_cycles, :end_date, true
  end
end
