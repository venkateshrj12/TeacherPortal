class CreateUserAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :user_accounts do |t|
      t.string :full_name, null: false
      t.string :full_phone_number
      t.string :country_code
      t.string :phone_number
      t.string :email
      t.boolean :activated, default: true
      t.string :password_digest, null: false
      t.string :user_name, null: false
      t.string :gender
      t.date :date_of_birth
      t.integer :role, default: 0
      t.datetime :last_visit_at

      t.timestamps
    end
  end
end
