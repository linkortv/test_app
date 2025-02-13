class CreateInterests < ActiveRecord::Migration[8.0]
  def change
    create_table :interests do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :interests, :name, unique: true

    reversible do |migration|
      migration.up do
        Interest.create!(name: 'Footboll')
        Interest.create!(name: 'Computer games')
        Interest.create!(name: 'Sport')
        Interest.create!(name: 'Cars')
      end
    end
  end
end
