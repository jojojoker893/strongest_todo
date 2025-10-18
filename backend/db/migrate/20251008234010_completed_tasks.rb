class CompletedTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :completed_tasks do |t|
      t.string :title, null: false
      t.text :description, null: true
      t.string :category, null: false

      t.timestamps
    end
  end
end
