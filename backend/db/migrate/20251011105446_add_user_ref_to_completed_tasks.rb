class AddUserRefToCompletedTasks < ActiveRecord::Migration[8.0]
  def change
    add_reference :completed_tasks, :user, null: false, foreign_key: true
  end
end
