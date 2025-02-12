class CreateSkills < ActiveRecord::Migration[8.0]
  def change
    create_table :skills do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :skills, :name, unique: true

    reversible do |migration|
      migration.up do
        Skill.create!(name: 'Ruby')
        Skill.create!(name: 'Rails')
        Skill.create!(name: 'JavaScript')
      end
    end
  end
end
