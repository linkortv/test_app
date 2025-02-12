class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :patronymic, null: true
      t.string :email, null: false
      t.integer :age, null: false
      t.string :nationality, null: true
      t.string :country, null: false
      t.string :gender, null: true

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
