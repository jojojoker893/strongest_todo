class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null:true
      t.string :category, null: false

      t.timestamps
    end
  end
end
