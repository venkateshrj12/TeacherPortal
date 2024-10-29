class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :full_name
      t.string :subject
      t.integer :marks
      t.references :user_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
