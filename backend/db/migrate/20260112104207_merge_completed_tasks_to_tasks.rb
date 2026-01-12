class MergeCompletedTasksToTasks < ActiveRecord::Migration[8.0]
  def change
    drop_table :completed_tasks do |t|
      t.string :title
      t.text :description
      t.bigint :user_id
      t.timestamps
    end

    add_column :tasks, :status, :integer, default: 0, null: false
  end
end
